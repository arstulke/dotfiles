{ config, pkgs, pkgs-unstable, nix-vscode-extensions, ... }:

{
  imports = [
    ../modules/airplay-server.nix
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
    ausweisapp

    # Jetbrains
    jetbrains.idea-ultimate
    pkgs-unstable.jetbrains.webstorm

    # VS Code
    (vscode-with-extensions.override {
      vscodeExtensions = let
        vscode-extensions = nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system};
      in
        with pkgs.lib.foldl' (acc: set: pkgs.lib.recursiveUpdate acc set) {} [
          vscode-extensions.vscode-marketplace
          vscode-extensions.open-vsx
          vscode-extensions.vscode-marketplace-release
          vscode-extensions.open-vsx-release
        ];
      [
        # general
        k--kato.intellij-idea-keybindings
        axelrindle.duplicate-file
        ms-azuretools.vscode-docker

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
    yubioath-flutter

    # 3d printing
    openscad
    prusa-slicer
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
      "terminal.integrated.fontSize" = 14;
    };

    home.file.".config/gtk-3.0/bookmarks".text = ''
      file:///etc/dotfiles dotfiles
      file:///home/arne/Desktop/projects projects
    '';
  };
}
