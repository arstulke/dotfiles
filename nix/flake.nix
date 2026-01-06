{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

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

    modulix = {
      url = "github:anders130/modulix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import inputs.nixpkgs {inherit system;};
        preCommitCheck = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
          };
        };
      in {
        formatter = pkgs.alejandra;
        checks.pre-commit-check = preCommitCheck;
        devShells.default = pkgs.mkShell {
          shellHook = preCommitCheck.shellHook;
        };
      }
    )
    // {
      nixosConfigurations = inputs.modulix.lib.mkHosts {
        inherit inputs;
        flakePath = "/etc/dotfiles/nix";
        modulesPath = ./modules;
        helpers = import ./lib;
        specialArgs = {
          hostname = "nixos";
          username = "arne";
          gitCreds.name = "Arne Stulken";
          gitCreds.email = "21034491+arstulke@users.noreply.github.com";
        };
        sharedConfig = {
          modules.bundles."10-shared".enable = true;
        };
      };
      overlays = import ./overlays.nix inputs;
    };
}
