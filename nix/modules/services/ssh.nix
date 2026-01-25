{
  pkgs,
  inputs,
  lib,
  username,
  ...
}: {
  options.authorizedKeys = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = ''
      List of OpenSSH public keys to install for the user ${username}.
      These are passed to users.users.${username}.openssh.authorizedKeys.keys.
    '';
    example = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... user@laptop"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ... user@desktop"
    ];
  };

  config = cfg: {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    networking.firewall = {
      allowedTCPPorts = [22];
      allowedUDPPorts = [];
    };

    users.users.${username}.openssh.authorizedKeys.keys = cfg.authorizedKeys;
  };
}
