{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../base/gui.nix
    ../../base/profiles/work-config.nix
  ];

  # Add graphics driver
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" "displaylink" "modesetting" ];

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
  swapDevices = [{
    device = "/swapfile";
    size = 8 * 1024; # 8 GiB
  }];

  # Network
  networking.hostName = "BTC-arstulke"; # Define your hostname.
}
