{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    linuxPackages.usbip # bind remote usb device from raspberry pi
  ];

  systemd.services.usbip-attach-remote = {
    description = "Attach remote USB device via usbip";
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c '${pkgs.linuxPackages.usbip}/bin/usbip attach --remote 192.168.0.21 --busid $(${pkgs.linuxPackages.usbip}/bin/usbip list -p --remote 192.168.0.21 | grep 0458:6006 | grep -oE "[0-9]+-[0-9]+\.[0-9]+")'
      '';
      ExecStop = "${pkgs.linuxPackages.usbip}/bin/usbip detach --port 0";
      Restart = "on-failure";
      RestartSec = 60;
      StartLimitIntervalSec = 0; # infinite retries
      StartLimitBurst = 0; # infinite retries
      RemainAfterExit = true;
      User = "root";
    };

    wantedBy = ["multi-user.target"];
  };
}
