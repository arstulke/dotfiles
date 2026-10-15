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
      # TODO fix this
      aw-watcher-afk = {
        package = pkgs.activitywatch;
        settings = {
          timeout = 300;
          poll_time = 2;
        };
      };

      # no additional watchers due to privacy concerns (regarding data processing for easier time tracking)
    };
  };
}
