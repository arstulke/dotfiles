{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    version = lib.mkOption {
      type = lib.types.str;
      default = "1.0.5";
      description = "Version of the AutoDarts container image.";
    };
    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/autodarts/config";
      description = "Directory to store AutoDarts configuration.";
    };
  };

  config = cfg: {
    networking.firewall.allowedTCPPorts = [3180];

    environment.systemPackages = with pkgs; [
      v4l-utils # utils for listing camera devices
    ];

    system.activationScripts.autodarts-config-dir = lib.stringAfter ["var"] ''
      mkdir -p ${cfg.configDir}
    '';

    virtualisation.oci-containers.containers.autodarts = {
      image = "docker.io/michvllni/autodarts:${cfg.version}";
      autoStart = true;

      ports = ["3180:3180"];

      volumes = [
        "${cfg.configDir}:/root/.config/autodarts" # required for config
        "/dev:/dev" # required for camera devices
      ];

      extraOptions = [
        "--device-cgroup-rule=c 81:* rmw" # required for camera devices
      ];
    };
  };
}
