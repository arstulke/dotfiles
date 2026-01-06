{
  lib,
  gitCreds,
  ...
}: {
  hm.programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      credential.helper = "store";
      user = gitCreds;
    };
  };
}
