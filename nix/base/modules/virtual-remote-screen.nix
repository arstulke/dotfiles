{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # gnome-remote-desktop # stream desktop to raspberry pi
    linuxPackages.usbip # bind remote usb device from raspberry pi
  ];

  ####################################################
  ########## stream desktop to raspberry pi ##########
  ####################################################
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

  home-manager.users.arne = {
    dconf.settings = {
      "org/gnome/mutter" = {
        experimental-features = ["scale-monitor-framebuffer" "xwayland-native-scaling" "variable-refresh-rate" "monitor-config-manager"];
      };
    };
  };

  ##############################################################
  ########## bind remote usb device from raspberry pi ##########
  ##############################################################
  systemd.services.usbip-attach-remote = {
    description = "Attach remote USB device via usbip";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c '${pkgs.linuxPackages.usbip}/bin/usbip attach --remote 192.168.0.21 --busid $(${pkgs.linuxPackages.usbip}/bin/usbip list -p --remote 192.168.0.21 | grep 0458:6006 | grep -oE "[0-9]+-[0-9]+\.[0-9]+")'
      '';
      ExecStop = "${pkgs.linuxPackages.usbip}/bin/usbip detach --port 0";
      RemainAfterExit = true;
      User = "root";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
