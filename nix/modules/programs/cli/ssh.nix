{
  config,
  pkgs,
  ...
}: {
  programs.ssh = {
    startAgent = true;
    hostKeyAlgorithms = ["ssh-ed25519" "ssh-rsa"];
    pubkeyAcceptedKeyTypes = ["ssh-ed25519" "ssh-rsa"];
  };
}
