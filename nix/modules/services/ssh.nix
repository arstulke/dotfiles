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

  options.openFirewall = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to open firewall for SSH (allow incoming connections on TCP port 22).";
  };

  config = cfg: {
    services.openssh = {
      enable = true;
      openFirewall = cfg.openFirewall;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false; # deny ssh authentication via ssh
        KbdInteractiveAuthentication = true; # allow interactive password prompt like sudo command requires, so password authentication is allowed after ssh connection via ssh key is established
      };
    };

    users.users.${username}.openssh.authorizedKeys.keys = cfg.authorizedKeys;
  };
}
