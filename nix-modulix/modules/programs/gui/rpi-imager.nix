{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [ rpi-imager ];
}
