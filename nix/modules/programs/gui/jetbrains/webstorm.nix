{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [unstable.jetbrains.webstorm];
}
