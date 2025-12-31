{ pkgs, lib, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    unstable.awscli2
    ssm-session-manager-plugin
  ];

  programs.fish.shellAbbrs = {
    edit-aws = "code ~/.aws/"; # TODO generalize for CLI only and for GUI (maybe define global alias for opening editor)
  };
}
