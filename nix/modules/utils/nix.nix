let
  nixSettings = builtins.fromJSON (builtins.readFile ../../nix-settings.json);
in
  {
    config,
    pkgs,
    username,
    ...
  }: {
    nix = {
      package = pkgs.nixVersions.stable;

      settings = rec {
        experimental-features = nixSettings."experimental-features";

        trusted-users = [username];
        substituters = nixSettings.substituters;
        trusted-public-keys = nixSettings."trusted-public-keys";
        trusted-substituters = substituters;
      };
    };
  }
