inputs: final: prev: {
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev) system;
    config.allowUnfree = true;
    config.permittedInsecurePackages = ["openclaw-2026.4.2"];
  };
}
