inputs: rec {
    all-channels = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
            inherit (prev) system;
            config.allowUnfree = true;
        };
    };

    default = inputs.nixpkgs.lib.composeManyExtensions [
        all-channels
    ];
}
