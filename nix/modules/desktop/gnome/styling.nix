{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    dconf-editor
    gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.clipboard-history
    gnomeExtensions.color-picker
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.system-monitor
    gnomeExtensions.user-themes
    yaru-theme
  ];

  hm.dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [];
      enabled-extensions = with pkgs; [
        gnomeExtensions.appindicator.extensionUuid
        gnomeExtensions.clipboard-history.extensionUuid
        gnomeExtensions.color-picker.extensionUuid
        gnomeExtensions.dash-to-dock.extensionUuid
        gnomeExtensions.gtk4-desktop-icons-ng-ding.extensionUuid
        gnomeExtensions.system-monitor.extensionUuid
        gnomeExtensions.user-themes.extensionUuid
      ];
    };
    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      show-battery-percentage = true;
      color-scheme = "prefer-dark";
      gtk-theme = "Yaru";
      cursor-theme = "Yaru";
      icon-theme = "Yaru";
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Yaru-dark";
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "LEFT";
      dock-fixed = true;
      extend-height = true;
      dash-max-icon-size = 42;
      click-action = "minimize-or-previews";
      multi-monitor = true;
      scroll-action = "cycle-windows";
      disable-overview-on-startup = true;
      running-indicator-style = "DOTS";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
      workspaces-only-on-primary = false;
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };
    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = false;
    };
  };
}
