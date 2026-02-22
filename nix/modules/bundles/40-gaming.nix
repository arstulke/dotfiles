{
  internalName,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  modules = {
    bundles."20-desktop".enable = true;

    hardware.xbox-controller.enable = true;

    programs.gui = {
      gaming = {
        minecraft.enable = mkDefault true;
        pokemmo.enable = mkDefault true;
        sunshine.enable = mkDefault true;
        steam.enable = mkDefault true;
      };
    };
  };
}
