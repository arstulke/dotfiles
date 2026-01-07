{ config, pkgs, ... }:

{
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  # self-explaining one-liners
  console.keyMap = "de";
  time.timeZone = "Europe/Berlin";
  nixpkgs.config.allowUnfree = true;

  # nix experimental features
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
        experimental-features = nix-command flakes
    '';
  };

  # locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };
  # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true;

  # user and group config
  users.groups.arne = {};
  users.users.arne = {
    isNormalUser = true;
    description = "Arne";
    initialPassword = "1qay!QAY";
    extraGroups = [ "arne" "networkmanager" "wheel" ];
  };

  #################################
  ########### LIBRARIES ###########
  #################################
  programs.nix-ld = {
    enable = true;
    dev.enable = false;
    libraries = with pkgs; [
      # Add here any missing dynamic libraries for unpackaged programs
    ];
  };

  #################################
  ############ PACKAGES ###########
  #################################

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # general
    git
    bash
    zip
    unzip
    vim
    nano
    jq  # format json
    exiftool
    podman-compose

    # network
    wget
    curl
    bind
    traceroute
    speedtest-cli
    static-web-server # http server
    nmap
    inetutils
    
    # hardware resources
    htop
    btop
    usbutils
    xsensors
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    jetbrains-mono
  ];

  #################################
  ###### PROGRAMS / SERVICES ######
  #################################
  
  services.gnome.gnome-keyring.enable = true;
  
  programs.ssh = {
    hostKeyAlgorithms      = [ "ssh-ed25519" "ssh-rsa" ];
    pubkeyAcceptedKeyTypes = [ "ssh-ed25519" "ssh-rsa" ];
  };

  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  programs.direnv.enable = true;
  programs.nh.enable = true;

  #################################
  ######### SHELL ALIASES #########
  #################################
  environment.shellAliases = {
    rebuild = "nh os switch /etc/dotfiles/nix -H $NIX_FLAKE_DEFAULT_HOST --impure";
    rebuild-test = "nh os test /etc/dotfiles/nix -H $NIX_FLAKE_DEFAULT_HOST --impure";
    update = "nix flake update --flake /etc/dotfiles/nix";
    free-nix = "sudo nix-collect-garbage --delete-older-than 30d";
    serve = "static-web-server --port 3000 --root ./";
    encrypt-as-zip = "#!/bin/bash\\nfunction _ezip() { zip --encrypt \"\${1}.zip\" \"\$1\"; }; _ezip";
  };

  #################################
  ########## HOME-MANAGER #########
  #################################
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.root = {
    # minimal home-manager config
    home.username = "root";
    home.stateVersion = "25.11";
  };
  home-manager.users.arne = {
    # basic home-manager config
    home.username = "arne";
    home.homeDirectory = "/home/arne";
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;

    # custom config
    programs.git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        credential.helper = "store";

        user = {
          name = "Arne Stulken";
          email = "21034491+arstulke@users.noreply.github.com";
        };
      };
    };
  };
}
