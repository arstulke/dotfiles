{
  config,
  pkgs,
  username,
  ...
}: {
  hm.xdg.userDirs = {
    enable = true;
    # setting unnecessary user directories to home dir to prevent programs to create them
    documents = "$HOME";
    music = "$HOME";
    publicShare = "$HOME";
    templates = "$HOME";
    videos = "$HOME";
  };

  system.userActivationScripts.manageDefaultDirs = ''
    mkdir -p /home/${username}/Desktop
    mkdir -p /home/${username}/Desktop/projects
  '';
}
