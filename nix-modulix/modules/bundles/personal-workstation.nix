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
            jetbrains.webstorm.enable = mkDefault true;
            "3d-printing".enable = mkDefault true;
            airplay-mirroring-server.enable = mkDefault true;
            ausweis-app.enable = mkDefault true;
            discord.enable = mkDefault true;
            obs.enable = mkDefault true;
            quick-share.enable = mkDefault true;
            rpi-imager.enable = mkDefault true;
            spotify.enable = mkDefault true;

            vscode.extensions = with pkgs.my-vscode-extension-sets; [
                # remote workspaces
                github.copilot
                github.codespaces

                # python
                ms-toolsai.jupyter
                ms-python.vscode-pylance
                ms-python.python

                # typescript
                denoland.vscode-deno
            ];
        };

        services = {
          firewall.matter.enable = mkDefault true;
          nocodb.enable = mkDefault true;
        };
    };
}