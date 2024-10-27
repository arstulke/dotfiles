{ config, pkgs, lib, nix-vscode-extensions, ... }:

{
  environment.systemPackages = with pkgs; [ uxplay ];

  services.avahi = {
    nssmdns4 = true;
    enable = true;
    publish = {
      enable = true;
      userServices = true;
      domain = true;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [7000 7001 7100];
    allowedUDPPorts = [5353 6000 6001 7011];
  };

  environment.shellAliases = {
    airplay-server = "uxplay -p";
  };
}
