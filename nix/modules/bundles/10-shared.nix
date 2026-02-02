{
  internalName,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  environment = {
    variables.NIX_FLAKE_DEFAULT_HOST = internalName;
  };

  modules = {
    hardware = {
      audio.enable = mkDefault true;
    };
    programs.cli = {
      fish.enable = mkDefault true;
      oh-my-posh.enable = mkDefault true;
      atuin.enable = mkDefault true;
      baseline.enable = mkDefault true;
      carapace.enable = mkDefault true;
      direnv.enable = mkDefault true;
      git.enable = mkDefault true;
      podman.enable = mkDefault true;
      ssh.enable = mkDefault true;
    };
    utils = {
      default-dirs.enable = mkDefault true;
      fonts.enable = mkDefault true;
      home-manager.enable = mkDefault true;
      lifecycle.enable = mkDefault true;
      locale.enable = mkDefault true;
      man.enable = mkDefault true;
      networking.enable = mkDefault true;
      nix-ld.enable = mkDefault true;
      nix.enable = mkDefault true;
      nixpkgs.enable = mkDefault true;
      users.enable = mkDefault true;
    };
  };
}
