{
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.enableNvidiaSupport = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable bambu-studio's workaround for OpenGL issues on Nvidia GPUs.";
  };

  config = cfg: {
    environment.systemPackages = with pkgs; [
      # 3D modeling
      openscad

      # 3D slicing
      ((unstable.bambu-studio.override {
          withNvidiaGLWorkaround = cfg.enableNvidiaSupport;
        }).overrideAttrs (old: {
          enableParallelBuilding = false;
        }))
    ];
  };
}
