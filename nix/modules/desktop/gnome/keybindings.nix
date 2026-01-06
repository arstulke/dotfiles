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
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-flameshot/"
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
      name = "Edit dotfile config";
      command = "code /etc/dotfiles/nix"; # TODO generalize for CLI only and for GUI (maybe define global alias for opening editor)
      binding = "<Super>c";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-flameshot" = let
      flameshot-gui = pkgs.writeShellScriptBin "flameshot-gui" "${pkgs.flameshot}/bin/flameshot gui";
    in {
      name = "Open flameshot (screenshot tool)";
      command = "${flameshot-gui}/bin/flameshot-gui";
      binding = "<Primary><Shift><Alt>section";
    };
  };
}
