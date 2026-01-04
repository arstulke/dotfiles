{ config, pkgs, ... }:

{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;

    settings = {
      # input
      controller = "disabled";
      keyboard = "disabled";
      mouse = "disabled";
      # audio/video
      stream_audio = "disabled";
      output_name = 1;
      # network
      origin_web_ui_allowed = "pc";
    };

    applications.apps = [
      {
        name = "Desktop";
        # exclude-global-prep-cmd = "false";
        # auto-detach = "true";
      }
    ];
  };

  # TODO Do I still need this?
  hm.dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer" "xwayland-native-scaling" "variable-refresh-rate" "monitor-config-manager"];
    };
  };
}
