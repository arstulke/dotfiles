{ pkgs, lib, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs_22
    yarn
    pnpm
  ];
}
