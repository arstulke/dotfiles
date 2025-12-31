{ config, pkgs, lib, ... }:

{
    options.git.username = lib.mkOption {
      type = lib.types.str;
      description = "Global Git username";
    };
    options.git.email = lib.mkOption {
      type = lib.types.str;
      description = "Global Git email";
    };

    hm.programs.git = {
        enable = true;
        settings = {
            user = {
                name = config.git.username;
                email = config.git.email;

                init.defaultBranch = "main";
                credential.helper = "store";
            };
        };
    };
}
