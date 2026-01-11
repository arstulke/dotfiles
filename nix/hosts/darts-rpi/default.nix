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
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJg+GUBJMuJiNJeEMiNdqNXyKHjf4IoBTv+oCJF8QJbL arne@arne-desktop"
      ];
    };

    services.autodarts = {
      enable = true;
      version = "1.0.5";
    };
    # TODO serve webcam via usbip
  };

  # NixOS & Home-Manager state
  system.stateVersion = "25.11";
  hm.home.stateVersion = "25.11";
}
