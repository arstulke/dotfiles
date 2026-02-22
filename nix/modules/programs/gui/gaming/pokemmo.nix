{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # plain `pokemmo-installer` doesn't work because of graphics issues probably Wayland stuff.
    # This wrapper unsets the WAYLAND_DISPLAY env var.
    (pkgs.symlinkJoin {
      name = "pokemmo-installer";
      paths = [pkgs.pokemmo-installer];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/pokemmo-installer \
          --set WAYLAND_DISPLAY ""
      '';
    })
  ];
}
