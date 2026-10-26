{
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nodejs_24
    yarn
    pnpm
  ];
}
