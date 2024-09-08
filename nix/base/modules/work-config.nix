{ config, pkgs, lib, nix-vscode-extensions, ... }:

{
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
        version = "1.93.0";
        plat = "linux-x64";
        src = fetchurl {
          name = "VSCode_${version}_${plat}.tar.gz";
          url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
          sha256 = "24BEzLDg5QLuB4G1OGB+lqEaH+Xy+WULbqaePJHElj4=";
        };
      });

      vscodeExtensions = let
        vscode-extensions = nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system};
      in
        with pkgs.lib.foldl' (acc: set: pkgs.lib.recursiveUpdate acc set) {} [
          vscode-extensions.vscode-marketplace
          # vscode-extensions.open-vsx # TODO use after ms-toolsai.jupyter is updated to v2024.8.x
          vscode-extensions.vscode-marketplace-release
          # vscode-extensions.open-vsx-release # TODO use after ms-toolsai.jupyter is updated to v2024.8.x
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

        # python
        ms-toolsai.jupyter
        ms-python.vscode-pylance
        ms-python.python
      ];
    })

    # AWS stuff
    awscli2

    # Javascript stuff
    nodejs_20  # switch to v22 in October 2024 (because it is currently not LTS)
    yarn

    # Python stuff (template to copy into nix devshell)
    # (python3.withPackages (python-pkgs: with python-pkgs; [
    #   numpy
    # ]))

    # other
    openvpn
    yubioath-flutter
    keepassxc
  ];

  #################################
  ###### PROGRAMS / SERVICES ######
  #################################
  services.pcscd.enable = true;

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

    programs.git.userEmail = lib.mkForce "41028207+arstulke-btc@users.noreply.github.com";
  };
}