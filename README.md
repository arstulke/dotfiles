# NixOS dotfiles

This is my multi-device NixOS configuration that I use at work and at home. It contains a Gnome configuration and a theming similar to the default Ubuntu design.

## TL;DR commands

- Update system's `flack.lock` file: `update`
- Rebuild system: `rebuild`


## TODO's

- setup & configure `personal-desktop`


## Initial setup

Prerequisites:
1. Create bootable USB-Stick


Notes for dual boot systems:
* Configure the Boot order in BIOS to boot in Linux. This boots the GRUB bootloader which also displays the Windows installation.


Steps:
1. Boot from NixOS bootable USB-Stick
2. Change keyboard layout
    1. on GUI use the settings
    2. on CLI ???
3. Configure partitions
    * for single boot:
        1. fat32 (512 MiB) with `boot` and `esp` flags
        2. ext4 (1024 MiB)
        3. ext4 (the remaining space)
4. Create and mount filesystems & prepare NixOS config
    ```
    sudo -i

    ### create file systems
    mkfs.vfat /dev/x1
    mkfs.ext4 /dev/x2
    cryptsetup luksFormat /dev/x3
    cryptsetup luksOpen /dev/x3 nixos
    mkfs.ext4 /dev/mapper/nixos

    ### mount partitions
    mount /dev/mapper/nixos /mnt
    mkdir /mnt/boot
    mount /dev/x2 /mnt/boot
    mkdir /mnt/boot/efi
    mount /dev/x1 /mnt/boot/efi

    ### generate default nixos config for my partitions
    nixos-generate-config --root /mnt
    ```
5. Configure grub in `/mnt/etc/nixos/configuration.nix`:
    ```
    boot.loader = {
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi";
        };
        systemd-boot.enable = false;
        grub = {
            enable = true;
            enableCryptodisk = true;
            device = "nodev";
            efiSupport = true;
        };
    };
    ```
6. Configure partition UUIDs in `/mnt/etc/nixos/hardware-configuration.nix`: `blkid /dev/xy`
7. Install NixOS default config
    ```
    ### install nixos
    nixos-install
    reboot  # boot into drive and enter disk encryption password

    ### troubleshooting (from live usb)
    # mount partitions in /mnt, /mnt/boot, /mnt/boot/efi (see above mount and decrypt commands)
    nixos-enter
    unset SUDO_USER
    nixos-rebuild boot --option sandbox false  # error "System not booted as systemd" can be ignored
    ```
8. Clone and install this repo
    ```
    # install git
    nix-shell -p git

    # change dir
    cd /etc

    # clone current commit
    git clone https://github.com/arstulke/dotfiles.git

    chown -R root:root /etc/dotfiles # not necessary, but makes editing files more comfortable
    chmod -R 755 /etc/dotfiles # should already be set like this

    # copy over your hardware-configuration.nix (!)
    cp -f /etc/nixos/hardware-configuration.nix /etc/dotfiles/nix/devices/<<DEVICE>>/

    # prefetch displaylink driver
    nix-prefetch-url --name displaylink-620.zip https://www.synaptics.com/sites/default/files/exe_files/2025-09/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.2-EXE.zip

    # rebuild nixos from flake config
    nixos-rebuild switch --flake /etc/dotfiles/nix#<<DEVICE>>

    # reboot the system
    reboot
    ```
9. Login as "arne" using "1qay!QAY" and update the password: `passwd`
10. Manual settings
    1. IntelliJ IDEA: sign-in and sync settings
    2. maybe generate ssh key: https://docs.github.com/de/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
    3. maybe store secret `ssh-config.txt` file as `~/.ssh/config`
    4. enable NoiseTorch: open NoiseTorch GUI and load the config
    5. for personal-config:
        1. Discord:
            1. Login
            2. On personal-desktop: Add Keybinding "Toggle Mute" on L1 macro key 
            3. On personal-desktop: Add Keybinding "Toggle Deafen" on L2 macro key 
        2. Spotify: Login
    6. for work-laptop:
        1. copy files from old system to home directory:
            1. `~/.aws/config`
            2. `~/.aws/credentials`
            3. `~/.npmrc`
            4. `~/.yarnrc`
            5. `~/.yarnrc.yml`
            6. `~/.kube/config`
        2. copy keepass file from old system to desktop
        3. copy OpenVPN profiles from old system to desktop or a subfolder & import the .ovpn file using the Networkmanager-GUI (see system Settings GUI > Network)


## Backup

Before erasing your system you need to backup the following dirs and files:

* In general:
    * `~/.ssh/config`
    * check everything outside a git repo
    * unpushed changes in git repos
    * maybe files ignored by git
* On work-laptop:
    * `~/.aws/config` and `~/.aws/credentials`
    * keepass file
    * OpenVPN profiles in `~/Desktop/openvpn`
