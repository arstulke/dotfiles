{
  username,
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.audioSink = lib.mkOption {
    type = lib.types.str;
    description = "The name of the audio sink used for audio loopback.";
    default = "";
  };

  options.virtualSink = lib.mkOption {
    type = lib.types.str;
    description = "The name of the virtual sink used for audio loopback.";
    default = "";
  };

  options.additionalGlobalPrepCmd = lib.mkOption {
    type = lib.types.listOf lib.types.attrs;
    description = "Additional global prep commands to run before starting Sunshine.";
    default = [];
  };

  config = cfg: {
    environment.systemPackages = with pkgs; [
      # configuring display resolution via cli
      inputs.displayconfig-mutter.packages.${pkgs.system}.default
    ];

    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;

      settings = {
        # general
        global_prep_cmd = builtins.toJSON [
          {
            do = "sh -c \"displayconfig-mutter set --connector DP-3 --resolution \${SUNSHINE_CLIENT_WIDTH}x\${SUNSHINE_CLIENT_HEIGHT} --refresh-rate \${SUNSHINE_CLIENT_FPS} --hdr false\"";
            undo = "displayconfig-mutter set --connector DP-3 --resolution 1920x1080 --refresh-rate 60 --hdr false";
          }
        ];

        # audio/video
        audio_sink = cfg.audioSink;
        virtual_sink = cfg.virtualSink;
        output_name = 1;

        # network
        origin_web_ui_allowed = "pc";
      };

      applications.apps = [
        {
          name = "Desktop";
          image-path = "desktop.png";
        }
        {
          name = "Steam";
          prep-cmd = [
            {
              undo = "sudo -u ${username} ${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam://close/bigpicture";
            }
          ];
          detached = ["sudo -u ${username} ${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam://open/bigpicture"];
          image-path = "steam.png";
        }
      ];
    };

    hm.dconf.settings = {
      "org/gnome/mutter" = {
        experimental-features = ["scale-monitor-framebuffer" "xwayland-native-scaling" "variable-refresh-rate" "monitor-config-manager"];
      };
    };
  };
}
