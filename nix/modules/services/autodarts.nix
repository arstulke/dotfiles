{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    version = lib.mkOption {
      type = lib.types.str;
      default = "1.0.4";
      description = "Version of the AutoDarts container image.";
    };
    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/autodarts/config";
      description = "Directory to store AutoDarts configuration.";
    };
    cameraDevices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["/dev/video0" "/dev/video1" "/dev/video2"];
      description = "List of camera device paths to be passed to the container.";
    };
  };

  config = cfg: {
    networking.firewall.allowedTCPPorts = [3180];

    virtualisation.oci-containers.containers.autodarts = {
      image = "docker.io/michvllni/autodarts:${cfg.version}";
      autoStart = true;
      extraOptions = ["--restart=unless-stopped"];

      ports = ["3180:3180"];

      volumes = [
        "${cfg.configDir}:/root/.config/autodarts"
      ];

      # Camera devices
      devices = builtins.map (d: "${d}:${d}") cfg.cameraDevices;
    };
  };
}
