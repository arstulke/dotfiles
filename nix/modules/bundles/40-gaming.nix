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

        programs.gui = {
          minecraft.enable = mkDefault true;
          sunshine.enable = mkDefault true;
          steam.enable = mkDefault true;
        };
    };
}