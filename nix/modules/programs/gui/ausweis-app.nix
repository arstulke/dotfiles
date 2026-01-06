{pkgs, ...}: {
  environment.systemPackages = with pkgs; [ausweisapp];

  networking.firewall = {
    allowedTCPPorts = [24727];
    allowedUDPPorts = [24727];
  };
}
