{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  options = {
    version = lib.mkOption {
      type = lib.types.str;
      default = "v3.0.1.15";
      description = "Version of the darts-caller container image.";
    };
    sha256 = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        "x86_64-linux" = "sha256-b7IvwepHIhNS1EVquC4PX7zLu7mfQzI8VULRn2kw78k=";
        "aarch64-linux" = "sha256-IsTDWuGJ6Ge+h/8L1nbG93021+qNRLt3tWsHUe8ODBE=";
      };
      example = {
        "x86_64-linux" = "sha256-abc123...";
        "aarch64-linux" = "sha256-def456...";
      };
      description = "A map of system (e.g. x86_64-linux, aarch64-linux) to hash string.";
    };

    startAfter = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["podman-autodarts.service"];
      description = "After which systemd service this service should start.";
    };

    autodartsBoardIdFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to a file containing the Autodarts board ID, readable when the
        service starts (e.g. the `path` of an `age.secrets.<name>` entry).
        The value is loaded at runtime via systemd's `LoadCredential=` so it
        never ends up baked into the Nix store.
      '';
    };
  };

  config = cfg: {
    networking.firewall.allowedTCPPorts = [8079];

    # TODO create dirs defined in "media_path" and "media_path_shared" before starting darts-caller

    systemd.services.darts-caller = let
      # preps for the nix package
      version = cfg.version;

      binaryName =
        {
          "x86_64-linux" = "darts-caller";
          "aarch64-linux" = "darts-caller-arm64";
        }.${
          pkgs.stdenv.hostPlatform.system
        } or (throw "darts-caller: unsupported system ${pkgs.stdenv.hostPlatform.system}");

      sha256 = cfg.sha256.${pkgs.stdenv.hostPlatform.system};

      src = pkgs.fetchurl {
        url = "https://github.com/Peschi90/darts-caller/releases/download/${version}/${binaryName}";
        sha256 = sha256;
      };

      dartsCaller = pkgs.stdenv.mkDerivation {
        pname = "darts-caller";
        inherit version src;

        # The release asset is a single stripped ELF – no build step required
        dontUnpack = true;
        dontBuild = true;

        nativeBuildInputs = [pkgs.autoPatchelfHook];

        # PyInstaller bundles glibc usage; autoPatchelf takes care of the rest
        buildInputs = [
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
        ];

        installPhase = ''
          install -Dm755 $src $out/bin/darts-caller
        '';
      };

      # props for executing the package (autodarts_board_id is injected at
      # runtime from the LoadCredential below, kept out of these static args
      # so it never lands in the Nix store)
      args = lib.cli.toCommandLineGNU {} {
        media_path = "/home/${username}/darts-caller/media";
        media_path_shared = "/home/${username}/darts-caller/media-shared";
        debug = "1"; # enables debug logs
      };

      startScript = pkgs.writeShellScript "darts-caller-start" ''
        exec ${dartsCaller}/bin/darts-caller ${lib.escapeShellArgs args} --autodarts_board_id "$(<"$CREDENTIALS_DIRECTORY/autodarts_board_id")"
      '';
    in {
      # systemd service definition
      description = "darts-caller - Hub for reacting to events of an autodarts.io game";
      wantedBy = ["multi-user.target"];
      after = ["network.target"] ++ cfg.startAfter;

      serviceConfig = {
        LoadCredential = "autodarts_board_id:${cfg.autodartsBoardIdFile}";
        ExecStart = startScript;
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
