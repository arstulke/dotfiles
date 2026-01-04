{
  username,
  flakePath,

  lib,
  ...
}:

{
    options.file-manager.bookmarks = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Bookmarks in Gnome file manager";
        default = [
            "file://${flakePath} dotfiles"
            "file:///home/${username}/Downloads Downloads"
            "file:///home/${username}/Pictures Pictures"
            "file:///home/${username}/Videos Videos"
            "file:///home/${username}/Desktop/projects projects"
        ];
    };

    config = cfg: {
        hm.home.file.".config/gtk-3.0/bookmarks" = {
            force = true;
            text = builtins.concatStringsSep "\n" cfg.file-manager.bookmarks;
        };
    };
}
