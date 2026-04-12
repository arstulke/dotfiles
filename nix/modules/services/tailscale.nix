{
  pkgs,
  lib,
  ...
}: {
  options.openFirewall = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to open firewall for Tailscale (allow incoming Wireguard connections from other Tailscale devices).";
  };

  config = cfg: {
    services.tailscale = {
      enable = true;
      disableTaildrop = true; # disable Taildrop (file sharing feature)
      disableUpstreamLogging = true; # disable uploading logs to Tailscale
    };
  };
}
