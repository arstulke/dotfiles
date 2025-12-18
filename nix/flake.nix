{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-ld = {
      url = "github:nix-community/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-openaws-vpn-client.url = "github:nixos/nixpkgs?rev=886c9aee6ca9324e127f9c2c4e6f68c2641c8256";
    openaws-vpn-client = {
      url = "github:JonathanxD/openaws-vpn-client";
      inputs.nixpkgs.follows = "nixpkgs-openaws-vpn-client";
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
