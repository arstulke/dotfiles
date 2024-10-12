{
    description = "Example Devshell for Node";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        flake-utils = {
            url = "github:numtide/flake-utils";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, flake-utils, ... }:
        flake-utils.lib.eachDefaultSystem (system: let
            pkgs = import nixpkgs { inherit system; };
        in {
            devShells.default = pkgs.mkShell {
                packages = with pkgs; [
                    nodejs_20
                    yarn
                ];
            };
        });
}