{
  config,
  pkgs,
  hostname,
  ...
}: {
  age.secrets."autodarts-board-id".file = ./_secrets/autodarts-board-id.age;

  modules = {
    # TODO declare wled-wled-gledopto config somewhere in this repo

    bundles."10-shared".enable = true;

    hardware = {
      audio.enable = false; # disabling audio because it is not required and maybe it reduces image size (enabled in "10-shared" by default)
      raspberry-pi.enable = true;
    };

    # TODO add tailscale?
    services.ssh = {
      enable = true;
      openFirewall = true;
      authorizedKeys = (import ../../variables/ssh-keys.nix).trusted-admins;
    };

    services.darts.autodarts = {
      enable = true;
      version = "1.0.7";
    };

    services.darts.darts-caller = {
      enable = true;
      startAfter = ["podman-autodarts.service"];

      autodartsBoardIdFile = config.age.secrets."autodarts-board-id".path;
    };

    services.darts.darts-wled = {
      enable = true;
      startAfter = ["darts-caller.service"];

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
  };

  # NixOS & Home-Manager state
  system.stateVersion = "26.05";
  hm.home.stateVersion = "26.05";
}
