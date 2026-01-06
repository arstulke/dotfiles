{pkgs, ...}: {
  modules = {
    bundles."20-desktop".enable = true;
    bundles."30-personal-machine".enable = true;
    bundles."40-gaming".enable = true;

    hardware.usbip-webcam-consumer.enable = true;

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
  };

  # Bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    systemd-boot.enable = false;
    grub = {
      enable = true;
      enableCryptodisk = true;
      useOSProber = true;
      device = "nodev";
      efiSupport = true;
    };
  };

  # Swapfile
  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024; # 8 GiB
    }
  ];

  # NixOS & Home-Manager state
  system.stateVersion = "25.11";
  hm.home.stateVersion = "25.11";
}
