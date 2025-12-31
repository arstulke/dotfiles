{ config, pkgs, ... }:

{
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  # self-explaining one-liners
  nixpkgs.config.allowUnfree = true;

  # nix experimental features
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
        experimental-features = nix-command flakes
    '';
  };

  # user and group config
  users.groups.arne = {};
  users.users.arne = {
    isNormalUser = true;
    description = "Arne";
    initialPassword = "1qay!QAY";
    extraGroups = [ "arne" "networkmanager" "wheel" ];
  };

  #################################
  ###### PROGRAMS / SERVICES ######
  #################################
  services.gnome.gnome-keyring.enable = true;

  #################################
  ########## HOME-MANAGER #########
  #################################
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
      settings.user = {
        name = "Arne Stulken";
        email = "21034491+arstulke@users.noreply.github.com";
      };
    };
  };
}
