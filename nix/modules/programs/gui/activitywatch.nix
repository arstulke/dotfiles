{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    activitywatch
    gnomeExtensions.focused-window-d-bus
  ];

  hm.dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = with pkgs; [
        gnomeExtensions.focused-window-d-bus.extensionUuid
      ];
    };
  };

  hm.services.activitywatch = {
    enable = true;
    watchers = {
      aw-watcher-afk = {
        package = pkgs.activitywatch;
        settings = {
          timeout = 300;
          poll_time = 2;
        };
      };

      aw-watcher-window = {
        package = pkgs.activitywatch;
        settings = {
          poll_time = 1;
        };
      };
    };
  };
}
