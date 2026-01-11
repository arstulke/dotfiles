{
  internalName,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  modules = {
    bundles."10-shared".enable = true;

    desktop.gnome.enable = mkDefault true;
    programs.cli = {
      oh-my-posh.profile = "gui";
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
