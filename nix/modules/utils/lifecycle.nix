{ config, pkgs, flakePath, ... }:

{
  programs.nh = {
      enable = true;
      flake = flakePath;
  };

  environment.shellAliases = {
    rebuild       = "nh os switch -H $NIX_FLAKE_DEFAULT_HOST --impure";
    rebuild-test  = "nh os test -H $NIX_FLAKE_DEFAULT_HOST --impure";
    update        = "nix flake update --flake ${flakePath}";
    free-nix      = "sudo nix-collect-garbage --delete-older-than 30d";
  };
}
