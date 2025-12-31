{
    username,
    lib,
    ...
}: {
    users.users.${username} =
        {
            isNormalUser = true;
            extraGroups = [
                "wheel"
                "networkmanager"
            ];
        };
}