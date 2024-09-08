{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, home-manager, nix-vscode-extensions }: {
    nixosConfigurations = builtins.mapAttrs (device: value: nixpkgs.lib.nixosSystem {
      system = value.system;
      specialArgs = {
        inherit nix-vscode-extensions;
        device = device;
      };
      modules = [
        ./base/minimum.nix
        ./devices/${device}/default.nix
        home-manager.nixosModules.home-manager
      ];
    }) {
      personal-desktop = { system = "x86_64-linux"; };
      personal-laptop = { system = "x86_64-linux"; };
      work-laptop = { system = "x86_64-linux"; };
    };
  };
}
