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
    };
  };

  # Ollama for local LLM inference
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama-cpu;
    loadModels = [
      "gemma4:e2b"
    ];
    host = "0.0.0.0"; # allows access from other devices on the network
    environmentVariables = {
      OLLAMA_NOHISTORY = "1";
      OLLAMA_MAX_LOADED_MODELS = "1";
      OLLAMA_KEEP_ALIVE = "30m";
      OLLAMA_NUM_PARALLEL = "2";
    };
  };
  environment.systemPackages = with pkgs; [unstable.llmfit];

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
  system.stateVersion = "25.11";
  hm.home.stateVersion = "25.11";
}
