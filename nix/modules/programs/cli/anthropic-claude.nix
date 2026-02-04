{
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    unstable.claude-code
    claude-monitor
  ];
}
