{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [ prismlauncher ];
}
