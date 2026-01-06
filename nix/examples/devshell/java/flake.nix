{
  description = "Example Devshell for Java";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      jdkpackage = pkgs.jdk23;
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          pkgs.maven
          jdkpackage
        ];

        JAVA_HOME = "${jdkpackage}/lib/openjdk";
        MAVEN_OPTS = "-Xmx2G";
      };
    });
}
