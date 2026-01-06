{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    openaws-vpn-client
  ];

  hm.xdg.desktopEntries.org-protocol = {
    name = "openaws-vpn-client";
    exec = "openaws-vpn-client";
    terminal = false;
    type = "Application";
  };
}
