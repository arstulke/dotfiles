{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../base/gui.nix
    ../../base/modules/personal-config.nix
  ];
    
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
  networking.hostName = "arne-desktop"; # Define your hostname.
}
