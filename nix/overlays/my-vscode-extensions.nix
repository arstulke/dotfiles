inputs: final: prev: let
  pkgs-ext = import inputs.nixpkgs {
    inherit (prev) system;
    config.allowUnfree = true;
    overlays = [inputs.nix-vscode-extensions.overlays.default];
  };
in {
  my-vscode-extension-pkgs = pkgs-ext;
  my-vscode-extension-sets = with pkgs-ext;
    lib.foldl' (acc: set: pkgs.lib.recursiveUpdate acc set)
    {}
    [
      vscode-marketplace
      open-vsx
      vscode-marketplace-release
      open-vsx-release
    ];
}
