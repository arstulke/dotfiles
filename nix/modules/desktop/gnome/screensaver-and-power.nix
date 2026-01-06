{
  config,
  pkgs,
  ...
}: {
  hm.dconf.settings = {
    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      sleep-inactive-battery-timeout = 900; # 15min
      sleep-inactive-battery-type = "nothing";
      sleep-inactive-ac-timeout = 900; # 15min
      sleep-inactive-ac-type = "nothing";
      power-button-action = "interactive";
    };
    "org/gnome/desktop/session" = {
      idle-delay = 300; # 5min
    };
    "org/gnome/desktop/screensaver" = {
      lock-enabled = true;
      lock-delay = 0; # 0sec
    };
  };
}
