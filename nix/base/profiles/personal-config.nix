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
        # remote workspaces
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
  ];

  #################################
  ########## HOME-MANAGER #########
  #################################
  home-manager.users.arne = {
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
          "org.gnome.Console.desktop"
        ];
      };
    };
  };
}
