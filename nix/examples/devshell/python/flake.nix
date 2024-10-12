{
    description = "Example Devshell for Python";

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
                    (python3.withPackages (python-pkgs: with python-pkgs; [
                        numpy # just an example
                    ]))
                ];
            };
        });
}