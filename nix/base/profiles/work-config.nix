{ pkgs, lib, inputs, ... }:

{
  imports = [
    ../modules/shell/fish-shell.nix
    
    ../modules/openaws-vpn-client.nix
    ../modules/nocodb.nix
    ../modules/logseq.nix
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
        # python
        ms-toolsai.jupyter
        ms-python.vscode-pylance
        ms-python.python

        # AWS
        amazonwebservices.aws-toolkit-vscode
      ];
    })
  ];

  #################################
  ########## HOME-MANAGER #########
  #################################
  home-manager.users.arne = {
    home.file.".config/Code/User/settings.json".text = builtins.toJSON {
      # Settings for AWS Toolkit & Sagemaker Remote access
      "aws.telemetry" = false;
      "remote.SSH.connectTimeout" = 120;
      "remote.SSH.defaultExtensions" = [
        "amazonwebservices.aws-toolkit-vscode"
      ];
    };

    home.file.".config/gtk-3.0/bookmarks" = {
      force = true;
      text = ''
        file:///home/arne/Desktop/notes notes
      '';
    };

    home.file.".ssh/config".text = ''
      Host ssh.dev.azure.com
        User git
        PubkeyAcceptedAlgorithms +ssh-rsa
        HostkeyAlgorithms +ssh-rsa
      
      Host vs-ssh.visualstudio.com
        User git
        PubkeyAcceptedAlgorithms +ssh-rsa
        HostkeyAlgorithms +ssh-rsa

      # Created by AWS Toolkit for VSCode. https://github.com/aws/aws-toolkit-vscode
      Host sm_*
        ForwardAgent yes
        AddKeysToAgent yes
        StrictHostKeyChecking accept-new
        ProxyCommand '/home/arne/.config/Code/User/globalStorage/amazonwebservices.aws-toolkit-vscode/sagemaker_connect' '%n'
        # User '%r'
    '';

    home.file.".config/Code/User/globalStorage/amazonwebservices.aws-toolkit-vscode/tools/Amazon/sessionmanagerplugin" = {
      source = "${pkgs.ssm-session-manager-plugin}";
    };

    programs.git = {
      settings = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "/home/arne/.ssh/id_ed25519.pub";
        
        user.email = lib.mkForce "41028207+arstulke-btc@users.noreply.github.com";
      };
    };

    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = [
          "chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop"     # Microsoft Teams PWA
          "chrome-pkooggnaalmfkidjmlhoelhdllpphaga-Default.desktop"     # Microsoft Outlook PWA
          "chrome-eejcciocfhhpepllfdanigebammgampf-Profile_5.desktop"   # Employee Self Service
          "chrome-fmpnliohjhemenmnlpbfagaolkdacoja-Default.desktop"     # Antrophic Claude
          "idea-ultimate.desktop"
          "Logseq.desktop"
        ];
      };
    };
  };
}
