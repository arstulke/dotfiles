{
  lib,
  pkgs,
  ...
}: let
  # custom GNOME extension showing the output of shell commands in the top bar (see ./_command-indicators)
  extension =
    pkgs.runCommand "gnome-shell-extension-command-indicators" {
      passthru.extensionUuid = "command-indicators@arstulke.github.io";
    } ''
      dir=$out/share/gnome-shell/extensions/command-indicators@arstulke.github.io
      mkdir -p $dir
      cp ${./_command-indicators/metadata.json} $dir/metadata.json
      cp ${./_command-indicators/extension.js} $dir/extension.js
    '';
in {
  # Other modules can add their own indicators, e.g.:
  #   modules.desktop.gnome.command-indicators.my-indicator.command = "${myScript}/bin/my-script";
  #
  # The first line of the command's output is shown in the top bar, all following lines in the menu of the indicator.
  # Each indicator is identified as "command-indicator-<name>" in the top bar order (see ./top-bar.nix).
  options.command-indicators = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        command = lib.mkOption {
          type = lib.types.str;
          description = "Shell command whose output is shown in the GNOME top bar.";
        };
        interval = lib.mkOption {
          type = lib.types.ints.positive;
          description = "Interval in seconds in which the command is executed.";
          default = 60;
        };
      };
    });
    description = "Indicators in the GNOME top bar showing the output of shell commands.";
    default = {};
  };

  config = cfg: {
    environment.systemPackages = [
      extension
    ];

    hm.dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          extension.extensionUuid
        ];
      };
    };

    hm.xdg.configFile."command-indicators/config.json".text = builtins.toJSON {
      indicators =
        lib.mapAttrsToList (name: indicator: {
          inherit name;
          inherit (indicator) command interval;
        })
        cfg.command-indicators;
    };
  };
}
