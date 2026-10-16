{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [spotifast];
}
