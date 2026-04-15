inputs: {
  hostname = "vps-01";
  username = "arne";
  modules = [
    inputs.openclaw.nixosModules.default
  ];
}
