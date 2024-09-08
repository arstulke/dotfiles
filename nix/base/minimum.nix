{ config, pkgs, device, ... }:

{
  environment.variables = {
    NIX_FLAKE_DEFAULT_HOST = device;
  };
}
