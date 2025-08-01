{ pkgs, lib, inputs, ... }:

{
  imports = [
    ../modules/shell/fish-shell.nix
    
    ../modules/openaws-vpn-client.nix
    ../modules/nocodb.nix
  ];

  #################################
  ############ PACKAGES ###########
  #################################

  # List GUI packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Jetbrains
    jetbrains.idea-ultimate

    # VS Code
    (vscode-with-extensions.override {
      # TODO remove after unstable updated to 1.93.0
      vscode = pkgs.vscode.overrideAttrs(old: rec {
        version = "1.96.0";
        plat = "linux-x64";
        src = fetchurl {
          name = "VSCode_${version}_${plat}.tar.gz";
          url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
          sha256 = "81M11Zt8NfKQvLgJ56Mjz/IXtm5qQJMrdpfdzD24dh0=";
        };
      });

      vscodeExtensions = let
        pkgs-ext = import inputs.nixpkgs {
          inherit (pkgs) system;
          config.allowUnfree = true;
          overlays = [ inputs.nix-vscode-extensions.overlays.default ];
        };
      in
        with pkgs.lib.foldl' (acc: set: pkgs.lib.recursiveUpdate acc set) {} (with pkgs-ext; [
          vscode-marketplace
          # open-vsx # TODO use after ms-toolsai.jupyter is updated to v2024.8.x
          vscode-marketplace-release
          # open-vsx-release # TODO use after ms-toolsai.jupyter is updated to v2024.8.x
        ]);
      [
        # general
        k--kato.intellij-idea-keybindings
        axelrindle.duplicate-file
        ms-azuretools.vscode-docker

        # mermaid
        bierner.markdown-mermaid

        # nix
        bbenoist.nix
        mkhl.direnv

        # remote workspaces
        ms-vscode-remote.remote-containers

        # python
        ms-toolsai.jupyter
        ms-python.vscode-pylance
        ms-python.python
      ];
    })

    # VSC
    gh
    github-desktop

    # AWS stuff
    awscli2
    ssm-session-manager-plugin

    # Kubernetes stuff
    kubectl
    kubernetes-helm
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-diff
      ];
    })
    k9s

    # Javascript stuff
    nodejs_20  # switch to v22 in October 2024 (because it is currently not LTS)
    yarn

    # other
    openvpn
    yubioath-flutter
    keepassxc
    thefuck
  ];

  #################################
  ###### PROGRAMS / SERVICES ######
  #################################
  services.pcscd.enable = true;

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
    };

    home.file.".config/gtk-3.0/bookmarks".text = ''
      file:///etc/dotfiles dotfiles
      file:///home/arne/Downloads Downloads
      file:///home/arne/Desktop/projects projects
    '';

    home.file.".ssh/config".text = ''
      Host ssh.dev.azure.com
        User git
        PubkeyAcceptedAlgorithms +ssh-rsa
        HostkeyAlgorithms +ssh-rsa
      
      Host vs-ssh.visualstudio.com
        User git
        PubkeyAcceptedAlgorithms +ssh-rsa
        HostkeyAlgorithms +ssh-rsa
    '';

    programs.git = {
      extraConfig = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "/home/arne/.ssh/id_ed25519.pub";
      };
      userEmail = lib.mkForce "41028207+arstulke-btc@users.noreply.github.com";
    };
  };
}
