{
  pkgs,
  lib,
  ...
}: {
  options.restrictTailnetFirewall = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Whether to set up a custom firewall chain for the tailscale interface instead of using Tailscale's built-in rules (ACCEPT all traffic from trusted tailnet).";
  };

  options.allowedTCPPorts = lib.mkOption {
    type = with lib.types; listOf int;
    default = [];
    description = "List of TCP ports to allow incoming traffic from trusted tailnet.";
  };

  options.allowedUDPPorts = lib.mkOption {
    type = with lib.types; listOf int;
    default = [];
    description = "List of UDP ports to allow incoming traffic from trusted tailnet.";
  };

  # TODO add option to disable this customized firewall

  config = cfg: {
    services.tailscale =
      {
        enable = true;
        disableTaildrop = true; # disable Taildrop (file sharing feature)
        disableUpstreamLogging = true; # disable uploading logs to Tailscale
      }
      // lib.optionalAttrs cfg.restrictTailnetFirewall {
        # disables Tailscale's built-in firewall rules for customization (https://tailscale.com/docs/reference/netfilter-modes#nodivert)
        extraUpFlags = "--netfilter-mode=nodivert";
      };

    systemd.services = lib.optionalAttrs cfg.restrictTailnetFirewall {
      tailscale-custom-firewall = {
        description = "Custom iptables chain (ts-custom-fw) after Tailscale";
        wantedBy = ["multi-user.target"];
        after = ["tailscaled.service" "network-online.target"];
        requires = ["tailscaled.service"];
        bindsTo = ["tailscaled.service"]; # tear down when tailscale stops

        serviceConfig = let
          chain = "ts-custom-fw";
          iptables = "${pkgs.iptables}/bin/iptables";
          ip6tables = "${pkgs.iptables}/bin/ip6tables";
        in {
          Type = "oneshot";
          RemainAfterExit = true;

          ExecStart = "${pkgs.writeShellScript "ts-custom-fw-up" ''
            set -euo pipefail

            # Helper command to manipulate both the IPv4 and IPv6 tables.
            ip46tables() {
              ${iptables} -w "$@"
              ${ip6tables} -w "$@"
            }

            #############################################################################
            ########### Revert custom jump rules so chain is never referenced  ##########
            #############################################################################
            ${iptables} -R ts-input 4 -i tailscale0 -j ACCEPT
            ${ip6tables} -R ts-input 2 -i tailscale0 -j ACCEPT

            #############################################################################
            ################## Flush, delete and re-create custom chain #################
            #############################################################################
            ip46tables -F ${chain} 2>/dev/null || true
            ip46tables -X ${chain} 2>/dev/null || true
            ip46tables -N ${chain}

            #############################################################################
            ######################### Add rules to custom chain #########################
            #############################################################################
            # Allowing established and related connections
            ip46tables -A ${chain} -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

            # Allowing TCP traffic on specified ports
            # TODO generate TCP accept rules dynamically from config option
            ip46tables -A ${chain} -p tcp -m tcp --dport 11434 -j ACCEPT

            # Allowing UDP traffic on specified ports
            # TODO generate UDP accept rules dynamically from config option
            # ip46tables -A ${chain} -p udp -m udp --dport 11434 -j ACCEPT

            # Allowing ICMP traffic
            ${iptables} -w -A ${chain} -p icmp --icmp-type echo-request -j ACCEPT
            ${ip6tables} -A ${chain} -p icmpv6 --icmpv6-type redirect -j DROP
            ${ip6tables} -A ${chain} -p icmpv6 --icmpv6-type 139 -j DROP
            ${ip6tables} -A ${chain} -p icmpv6 -j ACCEPT

            # Log and drop other traffic
            ip46tables -A ${chain} -j DROP

            #############################################################################
            ######## Create jump rule for tailscale0 interface in ts-input chain ########
            #############################################################################
            ${iptables} -R ts-input 4 -i tailscale0 -j ${chain}
            ${ip6tables} -R ts-input 2 -i tailscale0 -j ${chain}
          ''}";

          ExecStop = "${pkgs.writeShellScript "ts-custom-fw-down" ''
            set -euo pipefail

            # Replace jump rule with original ACCEPT
            ${iptables} -R ts-input 4 -i tailscale0 -j ACCEPT
            ${ip6tables} -R ts-input 2 -i tailscale0 -j ACCEPT

            # Flush and delete the custom chain
            ${iptables} -F ${chain} 2>/dev/null || true
            ${ip6tables} -F ${chain} 2>/dev/null || true
            ${iptables} -X ${chain} 2>/dev/null || true
            ${ip6tables} -X ${chain} 2>/dev/null || true
          ''}";
        };
      };
    };
  };
}
