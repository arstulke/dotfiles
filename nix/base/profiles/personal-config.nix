{ pkgs, inputs, ... }:

{
  #################################
  ########## HOME-MANAGER #########
  #################################
  home-manager.users.arne = {
    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = [
          "discord.desktop"
          "steam.desktop"
          "webstorm.desktop"
        ];
      };
    };
  };
}
