{
    internalName,
    username,
    flakePath,

    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkDefault;
in {
    modules = {
        bundles."20-desktop".enable = true;

        desktop.gnome.file-manager.bookmarks = [
            "file://${flakePath} dotfiles"
            "file:///home/${username}/Downloads Downloads"
            "file:///home/${username}/Pictures Pictures"
            "file:///home/${username}/Videos Videos"
            "file:///home/${username}/Desktop/notes notes"
            "file:///home/${username}/Desktop/projects projects"
        ];

        programs.cli = {
            aws-cli.enable = mkDefault true;
            aws-cli.prepVsCode = mkDefault true;
            nodejs_22.enable = mkDefault true;
            openvpn.enable = mkDefault true;
        };
        programs.gui = {
            jetbrains.intellij-idea-ultimate.enable = mkDefault true;
            github.enable = true;
            k8s.enable = true;
            logseq.enable = true;
            openaws-vpn-client.enable = true;

            vscode.extensions = with pkgs.my-vscode-extension-sets; [
                # python
                ms-toolsai.jupyter
                ms-python.vscode-pylance
                ms-python.python

                # AWS
                amazonwebservices.aws-toolkit-vscode
            ];
            vscode.settings = {
                # Settings for AWS Toolkit & Sagemaker Remote access
                "aws.telemetry" = false;
                "remote.SSH.connectTimeout" = 120;
                "remote.SSH.defaultExtensions" = [
                    "amazonwebservices.aws-toolkit-vscode"
                ];
            };
        };
        services = {
            nocodb.enable = true;
        };
    };

    hm.programs.git = {
        settings = {
            commit.gpgsign = true;
            gpg.format = "ssh";
            user.signingkey = "/home/${username}/.ssh/id_ed25519.pub";
        };
    };

    hm.home.file.".ssh/config".text = ''
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
        ProxyCommand '/home/${username}/.config/Code/User/globalStorage/amazonwebservices.aws-toolkit-vscode/sagemaker_connect' '%n'
        # User '%r'
    '';
}