{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    version = lib.mkOption {
      type = lib.types.str;
      default = "b2.0.1.8";
      description = "Version of the darts-wled binary.";
    };
    sha256 = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        "x86_64-linux" = "sha256-JaIcdZbWeNXwh3smMJNNQjKTKcOG1VdadxjOmBce6ig=";
        "aarch64-linux" = "sha256-HIytslPFltycebv04W2PgXDYPu31AXa4YENvJ4dwLqU=";
      };
      example = {
        "x86_64-linux" = "sha256-abc123...";
        "aarch64-linux" = "sha256-def456...";
      };
      description = "A map of system (e.g. x86_64-linux, aarch64-linux) to hash string of the binary.";
    };
    jsonSigSha256 = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        "x86_64-linux" = "sha256-wrmaU/Czyxr4Z0/qR9ydScDb7eRzo193wuWyJa3FOsM=";
        "aarch64-linux" = "sha256-82Rw19lnxtODrFPMIFYD4zn5NDB2Hu9QoOB19UvO4eY=";
      };
      description = "A map of system (e.g. x86_64-linux, aarch64-linux) to hash string of the JSON signature file.";
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
      example = lib.literalExpression ''
        {
          idle_effect       = "solid|white";
          game_won_effects  = "colortwinkles";
        }
      '';
      description = ''
        Additional arguments forwarded verbatim to darts-wled as
        <literal>--key=value</literal> pairs via
        <function>lib.cli.toCommandLineGNU</function>.
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
        url = "https://github.com/Peschi90/darts-wled/releases/download/${version}/${binaryName}";
        sha256 = sha256;
      };

      jsonSigSha256 = cfg.jsonSigSha256.${pkgs.stdenv.hostPlatform.system};
      jsonSigSrc = pkgs.fetchurl {
        url = "https://github.com/Peschi90/darts-wled/releases/download/${version}/manifest.sig.json-${binaryName}";
        sha256 = jsonSigSha256;
      };

      dartsWled = pkgs.stdenv.mkDerivation {
        pname = "darts-wled";
        inherit version src;

        # The release asset is a single stripped ELF – no build step required
        dontUnpack = true;
        dontBuild = true;

        installPhase = ''
          install -Dm755 $src $out/bin/darts-wled
          install -Dm644 ${jsonSigSrc} $out/bin/manifest.sig.json
        '';
      };

      # props for executing the package
      args = lib.cli.toCommandLineGNU {} (
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
