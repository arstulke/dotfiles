{inputs, ...}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };

    overlays = [inputs.self.overlays.default];
  };
}
