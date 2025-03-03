{ config, pkgs, device, inputs, ... }:

{
  nixpkgs.overlays = [inputs.self.overlays.default];

  environment.variables = {
    NIX_FLAKE_DEFAULT_HOST = device;
  };
}
