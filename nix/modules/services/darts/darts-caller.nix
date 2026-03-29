{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    version = lib.mkOption {
      type = lib.types.str;
      default = "2.20.3";
      description = "Version of the darts-caller container image.";
    };

    startAfter = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["podman-autodarts.service"];
      description = "After which systemd service this service should start.";
    };

    autodartsEmail = lib.mkOption {
      type = lib.types.str;
      description = "Autodarts e-mail";
    };
    autodartsPassword = lib.mkOption {
      type = lib.types.str;
      description = "Autodarts password";
    };
    autodartsBoardId = lib.mkOption {
      type = lib.types.str;
      description = "Autodarts board ID";
    };
  };

  config = cfg: {
    networking.firewall.allowedTCPPorts = [8079];

    systemd.services."podman-volume-create-darts-caller" = {
      description = "Create Podman volumes for darts-caller";
      before = ["podman-darts-caller.service"];
      wantedBy = ["podman-darts-caller.service"];
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.podman}/bin/podman volume create darts-caller || true
      '';
    };

    virtualisation.oci-containers.containers."darts-caller" = {
      image = "docker.io/lbormann/darts-caller:${cfg.version}";
      autoStart = true;

      ports = ["8079:8079"];

      devices = ["/dev/snd:/dev/snd"];

      environment = {
        AUTODARTS_EMAIL = cfg.autodartsEmail;
        AUTODARTS_PASSWORD = cfg.autodartsPassword;
        AUTODARTS_BOARD_ID = cfg.autodartsBoardId;
      };

      volumes = [
        "darts-caller:/usr/share/darts-caller"
      ];
    };

    systemd.services."podman-darts-caller" = {
      after = cfg.startAfter;
    };
  };
}
