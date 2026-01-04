{
    internalName,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkDefault;
in {
    modules = {
        programs.gui = {
          minecraft.enable = mkDefault true;
          sunshine.enable = mkDefault true;
          steam.enable = mkDefault true;
        };
    };
}