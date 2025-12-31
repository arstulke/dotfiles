{
    gitCredentials,
    pkgs,
    ...
}: {
    hm.programs.git = {
        inherit (gitCredentials) userEmail userName;
        enable = true;
        settings = {
            user = {
                name = "${secrets.git_credentials.username}";
                email = "${secrets.git_credentials.email}";

                init.defaultBranch = "main";
                credential.helper = "store";
            };
        };
    };
}
