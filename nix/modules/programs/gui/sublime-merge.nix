{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [sublime-merge];
}
