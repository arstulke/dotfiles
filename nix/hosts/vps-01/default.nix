{pkgs, ...}: {
  modules = {
    bundles."10-shared".enable = true;
    services = {
      tailscale = {
        enable = true;
        openFirewall = true;
      };
      ssh = {
        enable = true;
        openFirewall = false; # denying ssh access from the outside, only allow from tailscale
        authorizedKeys = import ../../variables/trusted-ssh-keys.nix;
      };
      ollama.enable = true;
    };
  };

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  # Swapfile
  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024; # 8 GiB
    }
  ];

  # NixOS & Home-Manager state
  system.stateVersion = "26.05";
  hm.home.stateVersion = "26.05";
}
