{
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # core module
    unstable.claude-code

    # useful for cli-only setups
    claude-monitor

    # useful for gnome desktops
    gnomeExtensions.claude-code-usage-indicator
  ];

  # useful for gnome desktops
  hm.dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = with pkgs; [
        gnomeExtensions.claude-code-usage-indicator.extensionUuid
      ];
    };
  };
}
