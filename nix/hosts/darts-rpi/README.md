# darts-rpi

This is the configuration of my Raspberry Pi.

## Installation

To install NixOS on this machine, follow these steps:

1. **build the image**

   ```bash
   nix build '.#nixosConfigurations.darts-rpi.config.system.build.sdImage'
   ```

2. **copy the image to the SD-Card**

   Insert the SD-Card into your machine and figure out the device name.

   ```bash
   sudo fdisk -l
   ```

   Burn the image on to the SD-Card:

   ```bash
   caligula burn ./result/sd-image/nixos-sd-image-name.img.zst
   ```

3. **Setup internet connection (optional)**

   ```
   wifi-connect [-h/--hidden] <SSID>
   ```
