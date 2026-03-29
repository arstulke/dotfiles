{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    version = lib.mkOption {
      type = lib.types.str;
      default = "1.10.4";
      description = "Version of the darts-wled binary.";
    };
    sha256 = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        "x86_64-linux" = "sha256-ctfeDWbsvAgJKV2zr9UBF5Z7UXu3wMvTEuyI/jrexEk=";
        "aarch64-linux" = "sha256-+s6dcNBG5m54PZE9ZGxE7gkJDfv4VIZ0r1fLQL14V1U=";
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
      example = ["podman-darts-caller.service"];
      description = "After which systemd service this service should start.";
    };

    dartsCallerConnection = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0:8079";
      description = "Connection string (host:port) for darts-caller events.";
    };
    wledEndpoints = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      example = ["192.168.1.50" "192.168.1.51"];
      description = ''
        One or more IP addresses of your WLED controllers.
        The first entry is treated as the primary endpoint.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      # TODO improve examples with actual parameters
      example = lib.literalExpression ''
        {
          idle_effect       = "solid|white";
          game_won_effects  = "colortwinkles";
        }
      '';
      description = ''
        Additional arguments forwarded verbatim to darts-wled as
        <literal>--key value</literal> pairs via
        <function>lib.cli.toGNUCommandLine</function>.
      '';
    };
  };

  config = cfg: {
    systemd.services.darts-wled = let
      # preps for the nix package
      version = cfg.version;

      binaryName =
        {
          "x86_64-linux" = "darts-wled";
          "aarch64-linux" = "darts-wled-arm64";
        }.${
          pkgs.stdenv.hostPlatform.system
        } or (throw "darts-wled: unsupported system ${pkgs.stdenv.hostPlatform.system}");

      sha256 = cfg.sha256.${pkgs.stdenv.hostPlatform.system};

      src = pkgs.fetchurl {
        url = "https://github.com/lbormann/darts-wled/releases/download/v${version}/${binaryName}";
        sha256 = sha256;
      };

      dartsWled = pkgs.stdenv.mkDerivation {
        pname = "darts-wled";
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
          install -Dm755 $src $out/bin/darts-wled
        '';
      };

      # props for executing the package
      args = lib.cli.toGNUCommandLine {} (
        {
          connection = cfg.dartsCallerConnection;
          wled_endpoints = cfg.wledEndpoints;
        }
        // cfg.extraArgs
      );
    in {
      # systemd service definition
      description = "darts-wled - WLED controller for autodarts.io";
      wantedBy = ["multi-user.target"];
      after = ["network.target"] ++ cfg.startAfter;

      serviceConfig = {
        ExecStart = "${dartsWled}/bin/darts-wled ${lib.escapeShellArgs args}";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
