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

    services.darts.autodarts = {
      enable = true;
      version = "1.0.6";
    };

    services.darts.darts-caller = {
      enable = true;
      startAfter = ["podman-autodarts.service"];

      # TODO store as secrets
      autodartsEmail = "";
      autodartsPassword = "";
      autodartsBoardId = "";
    };

    services.darts.darts-wled = {
      enable = true;
      startAfter = ["podman-darts-caller.service"];

      wledEndpoints = ["wled-wled-gledopto"];
      extraArgs = {
        idle_effect = "ps|25";
        calibration_effect = "ps|27";
        board_stop_effect = "ps|28";
        takeout_effect = "ps|26";
        game_won_effects = "colortwinkles";
        wled_off = "1";
        wled_off_at_start = "1";
      };
    };

    # TODO serve webcam via usbip
  };

  # NixOS & Home-Manager state
  system.stateVersion = "25.11";
  hm.home.stateVersion = "25.11";
}
