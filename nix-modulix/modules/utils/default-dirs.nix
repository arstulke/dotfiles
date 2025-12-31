{ config, pkgs, ... }:

{
  system.userActivationScripts.manageDefaultDirs = ''
    mkdir -p /home/$USER/Desktop
    mkdir -p /home/$USER/Desktop/projects
  '';
}
