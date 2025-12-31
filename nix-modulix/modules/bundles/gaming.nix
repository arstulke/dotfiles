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
        programs.gui = {
          minecraft.enable = mkDefault true;
          sunshine.enable = mkDefault true;
          steam.enable = mkDefault true;
        };
    };
}