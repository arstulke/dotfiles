{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [ prusa-slicer ];
}
