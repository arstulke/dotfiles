{
  lib,
  username,
  ...
}: let
  projectsRoot = "Desktop/projects/dotai";

  mkAlias = subdir: {
    name = "claude-${subdir}";
    value = let
      absDir = "/home/${username}/${projectsRoot}/${subdir}";
    in "mkdir -p ${absDir} && cd ${absDir} && claude && exit";
  };
in {
  options.subdirs = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = ''
      Subdirectories of ~/Desktop/projects/dotai for which to create a
      `claude-<subdir>` shell alias that cds into the project directory
      (creating it if needed) and launches claude.
    '';
  };

  config = cfg: {
    environment.shellAliases = lib.listToAttrs (map mkAlias cfg.subdirs);
  };
}
