inputs: {
  hostname = "darts-rpi";
  username = "arne";
  system = "aarch64-linux";
  modules = [
    ../../modules/hardware/raspberry-pi/_nixosSystemModule.nix
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-4.base
  ];
}
