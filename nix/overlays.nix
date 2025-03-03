inputs: rec {
    all-channels = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
            inherit (prev) system;
            config.allowUnfree = true;
        };
    };

    # TODO remove after project uses flakes correctly
    aws-vpn-client = final: prev: {
        aws-vpn-client = inputs.aws-vpn-client.defaultPackage.${prev.system};
    };

    default = inputs.nixpkgs.lib.composeManyExtensions [
        all-channels
        aws-vpn-client
    ];
}
