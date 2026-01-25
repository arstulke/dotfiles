{pkgs, ...}: {
  modules = {
    bundles."20-desktop".enable = true;
    bundles."30-personal-machine".enable = true;
    bundles."40-gaming".enable = true;

    desktop.gnome.dock.favorite-apps = [
      "org.keepassxc.KeePassXC.desktop"
      "com.yubico.yubioath.desktop"
      "google-chrome.desktop"
      "discord.desktop"
      "steam.desktop"
      "code.desktop"
      "webstorm.desktop"
      "sublime_merge.desktop"
      "org.gnome.Nautilus.desktop"
      "org.gnome.Console.desktop"
    ];

    # hardware.usbip-webcam-consumer.enable = true; # TODO enable after installing darts-rpi
  };

  # Add graphics driver
  boot.kernelParams = ["nouveau.modeset=0"]; # disabling nouveau (community opensource driver alternative for nvidia)
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = false; # opensource drivers only supported for Turing or later GPUs (RTX series, GTX 16xx)

  # Custom WirePlumber configuration
  environment.etc."wireplumber/wireplumber.conf.d/98-disable-devices.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            device.name = "alsa_card.pci-0000_01_00.1"
          }
          {
            device.name = "alsa_card.usb-SunplusIT_Inc_FHD_Camera_Microphone_01.00.00-02"
          }
          {
            device.name = "alsa_card.usb-Vimicro_corp._PC-LM1E_Camera_PC-LM1E_Audio-02"
          }
        ]
        actions = {
          update-props = {
            device.disabled = true
          }
        }
      }
    ]
  '';

  # Bootloader
  # TODO switch to GRUB
  # - current issue: installation of GRUB creates EFI entry in `efibootmgr` but it will be deleted during boot
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    systemd-boot.enable = true;
    timeout = 5;
  };

  # Emulate ARM CPU (required for cross-compiling RPi SD card image)
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Time
  time.hardwareClockInLocalTime = true; # using local time (required for dual boot with Windows because it stores the local time)

  # Swapfile
  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024; # 8 GiB
    }
  ];

  # Network
  networking = {
    # Enable Wake-on-LAN
    interfaces.enp5s0.wakeOnLan.enable = true;

    # VLANs
    vlans = {
      enp5s0_10_main = {
        id = 10;
        interface = "enp5s0";
      };
      enp5s0_30_lab = {
        id = 30;
        interface = "enp5s0";
      };
      enp5s0_40_iot = {
        id = 40;
        interface = "enp5s0";
      };
    };
    interfaces.enp5s0_10_main.useDHCP = true;
    interfaces.enp5s0_30_lab.useDHCP = true;
    interfaces.enp5s0_40_iot.useDHCP = true;
  };

  # NixOS & Home-Manager state
  system.stateVersion = "25.11";
  hm.home.stateVersion = "25.11";
}
