{
    username,
    lib,
    ...
}: {
    users.users.${username} = {
        initialPassword = "1qay!QAY";
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
    };
}