{
  config,
  pkgs,
  lib,
  ...
}: {
  hm.dconf.settings = {
    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      sleep-inactive-battery-timeout = 7200; # 2h
      sleep-inactive-battery-type = "nothing";
      sleep-inactive-ac-timeout = 7200; # 2h
      sleep-inactive-ac-type = "nothing";
      power-button-action = "interactive";
    };
    "org/gnome/desktop/session" = {
      idle-delay = lib.gvariant.mkUint32 0; # disables 'Automatic Screen Blank'
    };
    "org/gnome/desktop/screensaver" = {
      idle-activation-enabled = false;
      lock-enabled = false; # disables screen lock on screensaver
      lock-delay = lib.gvariant.mkUint32 0; # disables screensaver
    };
  };
}
