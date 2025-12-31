{ pkgs, inputs, ... }:

{
  # TODO parameterize the plugins

  environment.systemPackages = with pkgs; [
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
        ms-vscode-remote.remote-ssh
        ms-vscode.hexeditor

        # mermaid
        bierner.markdown-mermaid

        # nix
        bbenoist.nix
        mkhl.direnv

        # remote workspaces
        ms-vscode-remote.remote-containers
      ];
    })
  ];

  hm.home.file.".config/Code/User/settings.json".text = builtins.toJSON {
    "editor.wordWrap" = "on";
    "editor.fontSize" = 14;
    "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
    "terminal.integrated.fontSize" = 14;
    "markdown.preview.fontSize" = 20;
  };
}
