{ config, pkgs, ... }:

{
  hm.dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer" "xwayland-native-scaling"];
    };
  };
}
