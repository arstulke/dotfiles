{
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [logseq];
  nixpkgs.config.permittedInsecurePackages = ["electron-39.8.10"]; # TODO remove after logseq upgraded to electron 40+
}
