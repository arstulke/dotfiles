{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [rquickshare];

  networking.firewall = {
    allowedTCPPorts = [12345];
    allowedUDPPorts = [];
  };

  hm.home.file.".local/share/dev.mandre.rquickshare/.settings.json".text = builtins.toJSON {
    "autostart" = false;
    "startminimized" = false;
    "realclose" = true;
    "visibility" = 0;
    "download_path" = "/home/${username}/Downloads";
    "port" = 12345;
  };
}
