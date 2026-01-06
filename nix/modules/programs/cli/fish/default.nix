{
  lib,
  pkgs,
  ...
}: {
  programs.fish.enable = true;

  hm.programs.fish = {
    enable = true;
    interactiveShellInit =
      /*
      fish
      */
      ''
        source $HOME/.config/fish/extraConfig.fish
      '';
  };
  hm.xdg.configFile."fish/extraConfig.fish" = lib.mkSymlink ./config.fish;

  users.defaultUserShell = pkgs.fish;
}
