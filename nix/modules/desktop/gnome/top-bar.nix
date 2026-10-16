{
  lib,
  pkgs,
  ...
}: let
  itemList = description: default:
    lib.mkOption {
      type = lib.types.listOf lib.types.str;
      inherit description default;
    };
in {
  # Fixed order of the items in the GNOME top bar (via the Top Bar Organizer extension).
  #
  # Concept (left to right):
  #   left:   workspace indicator | glanceable read-only monitors
  #   center: clock (alone, so it stays centered and doesn't wobble when monitor values change width)
  #   right:  tray icons | on-demand tools | GNOME status indicators | system menu
  #
  # Items are identified by their panel role. Items listed here but not present on a machine are ignored.
  # Tray icons (AppIndicator/KStatusNotifierItem, e.g. sunshine or aw-manual) are identified as
  # "appindicator-kstatusnotifieritem-<app-id>". Unlisted items are added at the left end of the right box,
  # so tray icons land there automatically. To pin their order, look up their ids with
  # `dconf read /org/gnome/shell/extensions/top-bar-organizer/right-box-order` and add them to `right`.
  options.top-bar = {
    left = itemList "Order of the items in the left box of the GNOME top bar." [
      "activities" # workspace indicator
      "system-monitor@gnome-shell-extensions.gcampax.github.com"
      "ccusage-indicator@lordvcs.github.io" # claude usage monitor
    ];
    center = itemList "Order of the items in the center box of the GNOME top bar." [
      "dateMenu" # clock
    ];
    right = itemList "Order of the items in the right box of the GNOME top bar." [
      # on-demand tools (most used one closest to the corner)
      "color-picker@tuberry"
      "Clipboard History Indicator"

      # GNOME status indicators (only visible while active)
      "screenRecording"
      "screenSharing"
      "dwellClick"
      "a11y"
      "keyboard"

      "quickSettings" # sound, network, bluetooth, power etc.
    ];
  };

  config = cfg: {
    environment.systemPackages = with pkgs; [
      gnomeExtensions.top-bar-organizer
    ];

    hm.dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = with pkgs; [
          gnomeExtensions.top-bar-organizer.extensionUuid
        ];
      };
      "org/gnome/shell/extensions/top-bar-organizer" = {
        left-box-order = cfg.top-bar.left;
        center-box-order = cfg.top-bar.center;
        right-box-order = cfg.top-bar.right;
      };
    };
  };
}
