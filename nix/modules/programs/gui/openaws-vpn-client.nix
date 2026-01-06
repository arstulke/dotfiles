{
  config,
  pkgs,
  ...
}: {
  #################################
  ############ PACKAGES ###########
  #################################
  environment.systemPackages = with pkgs; [
    openaws-vpn-client
  ];

  #################################
  ########## HOME-MANAGER #########
  #################################
  hm.xdg.desktopEntries.org-protocol = {
    name = "openaws-vpn-client";
    exec = "openaws-vpn-client";
    terminal = false;
    type = "Application";
  };
}
