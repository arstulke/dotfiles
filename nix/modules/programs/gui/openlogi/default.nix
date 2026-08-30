{inputs, ...}: {
  # local-first alternative to Logitech Options+ (https://github.com/AprilNEA/OpenLogi)
  imports = [inputs.openlogi.nixosModules.default];
  programs.openlogi.enable = true;
}
