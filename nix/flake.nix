{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations = builtins.mapAttrs (device: value: inputs.nixpkgs.lib.nixosSystem {
      inherit (value) system;
      specialArgs = {
        inherit inputs device;
      };
      modules = [
        ./base/minimum.nix
        ./devices/${device}
        inputs.nix-ld.nixosModules.nix-ld
        inputs.home-manager.nixosModules.home-manager
      ];
    }) {
      personal-desktop = { system = "x86_64-linux"; };
      personal-laptop = { system = "x86_64-linux"; };
      work-laptop = { system = "x86_64-linux"; };
    };
    overlays = import ./overlays.nix inputs;
  };
}
