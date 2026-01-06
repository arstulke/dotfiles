{
  pkgs,
  lib,
  ...
}: {
  hm.programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

  hm.home.file.".config/atuin/config.toml".text = ''
    enter_accept = true

    filter_mode = "workspace"
    workspaces = true
  '';
}
