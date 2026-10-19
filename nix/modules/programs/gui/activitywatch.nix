{
  inputs,
  pkgs,
  ...
}: {
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
      # no additional watchers due to privacy concerns (regarding data processing for easier time tracking)
      # - aw-watcher-afk seems not to work on Wayland + Gnome
    };
  };

  # manual activity tracking for ActivityWatch (https://github.com/arstulke/aw-manual)
  home-manager.sharedModules = [inputs.aw-manual.homeManagerModules.default];
  hm.services.aw-manual.enable = true;
}
