{
  pkgs,
  hostname,
  ...
}: {
  modules = {
    bundles."10-shared".enable = true;

    hardware = {
      audio.enable = false; # disabling audio because it is not required and maybe it reduces image size (enabled in "10-shared" by default)
      raspberry-pi.enable = true;
    };

    services.ssh = {
      enable = true;
      openFirewall = true; # allowing ssh access is uncritical because this host is only reachable from local network
      authorizedKeys = import ../../variables/trusted-ssh-keys.nix;
    };

    services."3d-printing-controller" = {
      enable = true;
      corsDomains = [
        "http://localhost:8081"
        "http://${hostname}:8081"
      ];
      trustedClients = [
        "192.168.1.0/24" # TODO remove later
        "10.0.3.0/24"
      ];
    };
  };

  # NixOS & Home-Manager state
  system.stateVersion = "25.11";
  hm.home.stateVersion = "25.11";
}
