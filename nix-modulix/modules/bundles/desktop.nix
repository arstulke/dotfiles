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
        desktop = {
            gnome.enable = mkDefault true;
        };
        programs.gui = {
            baseline.enable = mkDefault true;
            noisetorch.enable = mkDefault true;
            printing.enable = mkDefault true;
            sublime-merge.enable = mkDefault true;
            vscode.enable = mkDefault true;
            yubico-authenticator.enable = mkDefault true;
        };
    };
}