{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../base/gui.nix
    ../../base/profiles/personal-config.nix
  ];

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
    hostName = "arne-desktop";
    interfaces.enp5s0.wakeOnLan.enable = true;
  };
}
