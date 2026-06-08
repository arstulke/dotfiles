{pkgs, ...}: {
  modules = {
    bundles."10-shared".enable = true;
    hardware = {
      audio.enable = false; # disabling audio because it is not required and maybe it reduces image size (enabled in "10-shared" by default)
      raspberry-pi.enable = true;
    };
    # TODO serve autodarts
    # TODO serve webcam via usbip
  };

  # NixOS & Home-Manager state
  system.stateVersion = "26.05";
  hm.home.stateVersion = "26.05";
}
