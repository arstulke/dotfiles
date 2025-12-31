{ config, pkgs, ... }:

{
  #################################
  ############ PACKAGES ###########
  #################################
  environment.systemPackages = with pkgs; [
    openaws-vpn-client
  ];

  #################################
  ########## HOME-MANAGER #########
  #################################
  home-manager.users.arne = {
    xdg.desktopEntries.org-protocol = {
      name = "openaws-vpn-client";
      exec = "openaws-vpn-client";
      terminal = false;
      type = "Application";
    };
  };
}
