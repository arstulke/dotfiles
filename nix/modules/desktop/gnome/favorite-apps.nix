{lib, ...}: {
  options.dock.favorite-apps = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Favorite apps in Gnome dock";
    default = [
      "org.gnome.Nautilus.desktop"
      "org.gnome.Console.desktop"
    ];
  };

  config = cfg: {
    hm.dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = cfg.dock.favorite-apps;
      };
    };
  };
}
