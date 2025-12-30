{ pkgs, inputs, ... }:

{
  imports = [
    ../modules/shell/fish-shell.nix
    
    ../modules/airplay-server.nix
    ../modules/ausweis-app.nix
    ../modules/nocodb.nix
    ../modules/quick-share.nix
    ../modules/virtual-remote-screen.nix
  ];

  #################################
  ############ PACKAGES ###########
  #################################

  # List GUI packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # general
    discord
    spotify

    # Jetbrains
    unstable.jetbrains.webstorm

    # VS Code
    (vscode-with-extensions.override {
      vscodeExtensions = let
        pkgs-ext = import inputs.nixpkgs {
          inherit (pkgs) system;
          config.allowUnfree = true;
          overlays = [ inputs.nix-vscode-extensions.overlays.default ];
        };
      in
        with pkgs.lib.foldl' (acc: set: pkgs.lib.recursiveUpdate acc set) {} (with pkgs-ext; [
          vscode-marketplace
          open-vsx
          vscode-marketplace-release
          open-vsx-release
        ]);
      [
        # general
        k--kato.intellij-idea-keybindings
        axelrindle.duplicate-file
        ms-azuretools.vscode-docker
        ms-vscode.hexeditor

        # mermaid
        bierner.markdown-mermaid

        # nix
        bbenoist.nix
        mkhl.direnv

        # remote workspaces
        ms-vscode-remote.remote-containers
        github.copilot
        github.codespaces

        # python
        ms-toolsai.jupyter
        ms-python.vscode-pylance
        ms-python.python

        # typescript
        denoland.vscode-deno
      ];
    })

    # other coding stuff
    rpi-imager

    # 3d printing
    openscad
    prusa-slicer

    # gaming
    prismlauncher

    # other
    # (currently empty)
  ];

  #################################
  ###### PROGRAMS / SERVICES ######
  #################################
  networking.firewall = {
    allowedTCPPorts = [];
    allowedUDPPorts = [
      # Matter IoT protocol
      5353 # mDNS
      5540 # Matter
    ];
  };

  services.pcscd.enable = true; # required for Yubico Authenticator

  services.ollama = {
    enable = false;
    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_NUM_PARALLEL = "2";
      OLLAMA_MAX_LOADED_MODELS = "2";
      OLLAMA_NOHISTORY = "1";
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.obs-studio = {
    enable = true;
  };

  #################################
  ######### SHELL ALIASES #########
  #################################
  programs.fish.shellAbbrs = {
    edit-aws = "code ~/.aws/";
  };

  #################################
  ########## HOME-MANAGER #########
  #################################
  home-manager.users.arne = {
    home.file.".config/Code/User/settings.json".text = builtins.toJSON {
      "editor.wordWrap" = "on";
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
      "terminal.integrated.fontSize" = 14;
      "markdown.preview.fontSize" = 20;
    };

    home.file.".config/gtk-3.0/bookmarks" = {
      force = true;
      text = ''
        file:///etc/dotfiles dotfiles
        file:///home/arne/Downloads Downloads
        file:///home/arne/Pictures Pictures
        file:///home/arne/Videos Videos
        file:///home/arne/Desktop/projects projects
      '';
    };

    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = [
          "org.keepassxc.KeePassXC.desktop"
          "com.yubico.yubioath.desktop"
          "google-chrome.desktop"
          "discord.desktop"
          "steam.desktop"
          "code.desktop"
          "webstorm.desktop"
          "sublime_merge.desktop"
          "org.gnome.Nautilus.desktop"
          "Logseq.desktop"
          "org.gnome.Console.desktop"
        ];
      };
    };
  };
}
