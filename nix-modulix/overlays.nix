inputs: rec {
    all-channels = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
            inherit (prev) system;
            config.allowUnfree = true;
        };
    };

    # TODO remove after project uses flakes correctly
    openaws-vpn-client = final: prev: {
        openaws-vpn-client = inputs.openaws-vpn-client.defaultPackage.${prev.system};
    };

    default = inputs.nixpkgs.lib.composeManyExtensions [
        all-channels
        openaws-vpn-client
    ];
}
