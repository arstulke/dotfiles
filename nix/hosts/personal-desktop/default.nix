{ pkgs, ... }:

{
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

    # Add graphics driver
    boot.kernelParams = [ "nouveau.modeset=0" ]; # disabling nouveau (community opensource driver alternative for nvidia)
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = false; # opensource drivers only supported for Turing or later GPUs (RTX series, GTX 16xx)

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

    # Time
    time.hardwareClockInLocalTime = true; # using local time (required for dual boot with Windows because it stores the local time)

    # Swapfile
    swapDevices = [{
        device = "/swapfile";
        size = 8 * 1024; # 8 GiB
    }];

    # Network
    networking = {
        interfaces.enp5s0.wakeOnLan.enable = true;
    };

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