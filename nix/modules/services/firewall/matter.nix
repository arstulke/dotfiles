{
  pkgs,
  inputs,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [];
    allowedUDPPorts = [
      5353 # mDNS
      5540 # Matter
    ];
  };
}
