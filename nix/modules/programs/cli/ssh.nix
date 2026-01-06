{
  config,
  pkgs,
  ...
}: {
  programs.ssh = {
    hostKeyAlgorithms = ["ssh-ed25519" "ssh-rsa"];
    pubkeyAcceptedKeyTypes = ["ssh-ed25519" "ssh-rsa"];
  };
}
