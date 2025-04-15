{ pkgs, inputs, ... }:

{
  imports = [
    ../modules/shell/fish-shell.nix
    
    ../modules/airplay-server.nix
    ../modules/ausweis-app.nix
    ../modules/nocodb.nix
    ../modules/quick-share.nix
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
    jetbrains.idea-ultimate
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
    yubioath-flutter
    keepassxc
    thefuck
  ];

  #################################
  ###### PROGRAMS / SERVICES ######
  #################################
  services.pcscd.enable = true; # required for Yubico Authenticator

  networking.firewall = {
    allowedTCPPorts = [];
    allowedUDPPorts = [
      # Matter IoT protocol
      5353 # mDNS
      5540 # Matter
    ];
  };

  #################################
  ######### SHELL ALIASES #########
  #################################
  # no additional config (see nix/base/gui.nix)

  #################################
  ########## HOME-MANAGER #########
  #################################
  home-manager.users.arne = {
    home.file.".config/Code/User/settings.json".text = builtins.toJSON {
      "editor.wordWrap" = "on";
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
      "terminal.integrated.fontSize" = 14;
    };

    home.file.".config/gtk-3.0/bookmarks".text = ''
      file:///etc/dotfiles dotfiles
      file:///home/arne/Downloads Downloads
      file:///home/arne/Desktop/projects projects
    '';
  };
}
