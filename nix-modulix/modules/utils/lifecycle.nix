{ config, pkgs, ... }:

{
  programs.nh.enable = true;

  environment.shellAliases = {
    rebuild       = "nh os switch /etc/dotfiles/nix -H $NIX_FLAKE_DEFAULT_HOST --impure";
    rebuild-test  = "nh os test /etc/dotfiles/nix -H $NIX_FLAKE_DEFAULT_HOST --impure";
    update        = "nix flake update --flake /etc/dotfiles/nix";
    free-nix      = "sudo nix-collect-garbage --delete-older-than 30d";
  };
}
