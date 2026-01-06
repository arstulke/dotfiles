{
  pkgs,
  lib,
  inputs,
  ...
}: let
  defaultExtensions = with pkgs.my-vscode-extension-sets; [
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

  defaultSettings = {
    "editor.wordWrap" = "on";
    "editor.fontSize" = 14;
    "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
    "terminal.integrated.fontSize" = 14;
    "markdown.preview.fontSize" = 20;
  };
in {
  options.default-extensions.enable = lib.mkOption {
    type = lib.types.bool;
    description = "Whether to install the default extensions.";
    default = true;
  };
  options.extensions = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [];
    example = lib.literalExpression ''
      with pkgs.my-vscode-extension-sets; [
          ms-toolsai.jupyter
          ms-python.python
      ]
    '';
    description = "List of VS Code extensions to install.";
  };
  options.settings = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = {};
    description = "VS Code settings to merge with defaults.";
  };

  config = cfg: {
    environment.systemPackages = with pkgs; [
      (vscode-with-extensions.override {
        vscodeExtensions =
          lib.optionals cfg.default-extensions.enable defaultExtensions
          ++ cfg.extensions;
      })
    ];

    hm.home.file.".config/Code/User/settings.json".text = builtins.toJSON (lib.recursiveUpdate defaultSettings cfg.settings);
  };
}
