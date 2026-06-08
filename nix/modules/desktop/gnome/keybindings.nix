{
  config,
  pkgs,
  ...
}: {
  hm.dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-open-terminal/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-open-filemanager/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-edit-config/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-gradia/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-open-terminal" = {
      name = "Open terminal";
      command = "kgx";
      binding = "<Super>r";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-open-filemanager" = {
      name = "Open file manager";
      command = "nautilus ./Downloads";
      binding = "<Super>e";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-edit-config" = {
      name = "Edit dotfiles config";
      command = "code --new-window /etc/dotfiles/nix";
      binding = "<Super>c";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-gradia" = let
      gradia-screenshot = pkgs.writeShellScriptBin "gradia-screenshot" "${pkgs.gradia}/bin/gradia --screenshot";
    in {
      name = "Open gradia (screenshot tool)";
      command = "${gradia-screenshot}/bin/gradia-screenshot";
      binding = "<Primary><Shift><Alt>section";
    };
  };
}
