{
  pkgs,
  lib,
  inputs,
  ...
}: let
  originalGnomeExt = pkgs.gnomeExtensions.claude-code-usage-indicator;
  patchedGnomeExt = pkgs.runCommand "patched-claude-code-usage-indicator" {} ''
    # Copy the entire package output
    cp -r ${originalGnomeExt} $out
    chmod -R +w $out

    # Read the original JSON, modify it, write it back
    file=share/gnome-shell/extensions/ccusage-indicator@lordvcs.github.io/metadata.json
    cat ${originalGnomeExt}/$file \
      | ${pkgs.jq}/bin/jq '."shell-version" += ["49", "50"]' \
      > $out/$file
  '';

  ccUsageCommand = pkgs.writeShellScriptBin "ccusage" ''
    PATH=$PATH:${pkgs.nodejs_24}/bin ${pkgs.nodejs_24}/bin/npx ccusage "$@"
  '';
in {
  environment.systemPackages = with pkgs; [
    unstable.claude-code

    # usage monitor
    claude-monitor # in CLI
    patchedGnomeExt # in gnome statusbar
  ];

  # usage monitor in gnome statusbar
  hm.dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = with pkgs; [
        gnomeExtensions.claude-code-usage-indicator.extensionUuid
      ];
    };
    "org/gnome/shell/extensions/ccusage-indicator" = {
      "ccusage-command" = "${ccUsageCommand}/bin/ccusage";
    };
  };
}
