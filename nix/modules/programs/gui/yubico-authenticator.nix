{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [yubioath-flutter];
  services.pcscd.enable = true;
}
