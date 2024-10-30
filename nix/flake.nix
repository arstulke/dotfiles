{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-vscode-extensions, nix-ld }: {
    nixosConfigurations = builtins.mapAttrs (device: value: nixpkgs.lib.nixosSystem {
      system = value.system;
      specialArgs = {
        inherit nix-vscode-extensions;
        device = device;
        pkgs-unstable = import nixpkgs-unstable {
          system = value.system;
          config.allowUnfree = true;
        };
      };
      modules = [
        ./base/minimum.nix
        ./devices/${device}/default.nix
        nix-ld.nixosModules.nix-ld
        home-manager.nixosModules.home-manager
      ];
    }) {
      personal-desktop = { system = "x86_64-linux"; };
      personal-laptop = { system = "x86_64-linux"; };
      work-laptop = { system = "x86_64-linux"; };
    };
  };
}
