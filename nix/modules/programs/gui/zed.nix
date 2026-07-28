{
  username,
  lib,
  ...
}: {
  options.forceXWayland = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Workaround for Zed under Wayland (forces XWayland-Fallback).";
  };

  config = cfg: {
    home-manager.users.${username} = {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "biome"
          "dockerfile"
          "fish"
          "mermaid"
          "nix"
        ];
        userSettings = {
          auto_install_extensions = {
            biome = true;
            dockerfile = true;
            fish = true;
            mermaid = true;
            nix = true;
          };
          autosave = {
            after_delay = {
              milliseconds = 500;
            };
          };
          base_keymap = "JetBrains";
          cli_default_open_behavior = "existing_window";
          git_panel = {
            # tree_view= true;
            dock = "left";
          };
          load_direnv = "shell_hook";
          project_panel = {
            dock = "left";
          };
          theme = {
            mode = "dark";
            dark = "Ayu Dark";
          };
          title_bar = {
            show_menus = true;
          };
        };
      };

      xdg.desktopEntries."dev.zed.Zed" = lib.mkIf cfg.forceXWayland {
        name = "Zed";
        exec = "env WAYLAND_DISPLAY= zeditor %F";
        icon = "zed";
        comment = "A high-performance, multiplayer code editor";
        categories = ["TextEditor" "Development" "IDE"];
        mimeType = [
          "text/plain"
          "inode/directory"
        ];
      };

      programs.fish.shellAliases = lib.mkIf cfg.forceXWayland {
        zeditor = "env WAYLAND_DISPLAY= zeditor";
      };
    };
  };
}
