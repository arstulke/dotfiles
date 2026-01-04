{ lib, gitCreds, ... }:

{
    hm.programs.git = {
        enable = true;
        settings = {
            user = {
                inherit (gitCreds) email name;

                init.defaultBranch = "main";
                credential.helper = "store";
            };
        };
    };
}
