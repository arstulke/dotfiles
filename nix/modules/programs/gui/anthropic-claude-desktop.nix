{
  pkgs,
  username,
  ...
}: {
  # unofficial Claude Desktop package for Linux (https://github.com/patrickjaja/claude-desktop-extra)
  environment.systemPackages = with pkgs; [claude-desktop];

  # Cowork runs its agent VM via QEMU/KVM
  users.users.${username}.extraGroups = ["kvm"];
}
