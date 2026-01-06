{pkgs, ...}: {
  modules = {
    bundles."20-desktop".enable = true;
    bundles."31-work-machine".enable = true;

    desktop.gnome.dock.favorite-apps = [
      "chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop" # Microsoft Teams PWA
      "chrome-pkooggnaalmfkidjmlhoelhdllpphaga-Default.desktop" # Microsoft Outlook PWA
      "org.keepassxc.KeePassXC.desktop"
      "com.yubico.yubioath.desktop"
      "google-chrome.desktop"
      "chrome-eejcciocfhhpepllfdanigebammgampf-Profile_5.desktop" # Employee Self Service
      "chrome-fmpnliohjhemenmnlpbfagaolkdacoja-Default.desktop" # Antrophic Claude
      "code.desktop"
      "idea-ultimate.desktop"
      "sublime_merge.desktop"
      "org.gnome.Nautilus.desktop"
      "Logseq.desktop"
      "org.gnome.Console.desktop"
    ];
  };

  # Add graphics driver
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu" "displaylink" "modesetting"];

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

  # TODO delete later if not needed
  programs.nix-ld = {
    enable = true;
    #        dev.enable = false;
    libraries = with pkgs; [
      # Add here any missing dynamic libraries for unpackaged programs
    ];
  };

  # NixOS & Home-Manager state
  system.stateVersion = "25.11";
  hm.home.stateVersion = "25.11";
}
