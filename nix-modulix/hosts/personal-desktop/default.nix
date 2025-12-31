{
    modules = {
    };

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

    system.stateVersion = "25.11";
}