let
  sshKeys = import ../../../variables/ssh-keys.nix;
in {
  "autodarts-board-id.age" = {
    publicKeys = sshKeys.trusted-admins ++ [sshKeys."root@darts-rpi"];
    armor = true;
  };
}
