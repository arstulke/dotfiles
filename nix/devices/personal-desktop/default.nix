{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../base/gui.nix
    ../../base/modules/personal-config.nix
  ];
    
  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "/dev/vda"; # Define GRUB device
  boot.loader.timeout = 25; # timeout for switching GRUB config manually (useful for dual boot)

  # Swapfile
  swapDevices = [{
    device = "/swapfile";
    size = 8 * 1024; # 8 GiB
  }];

  # Network
  networking.hostName = "arne-desktop"; # Define your hostname.
}
