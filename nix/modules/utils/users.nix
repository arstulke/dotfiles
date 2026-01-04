{
    username,
    lib,
    ...
}: {
    users.users.${username} = {
        description = lib.capitalize username;
        initialPassword = "1qay!QAY";
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
    };
}