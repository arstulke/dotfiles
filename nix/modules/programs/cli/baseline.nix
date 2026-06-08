{
  username,
  flakePath,
  config,
  lib,
  pkgs,
  ...
}: {
  options.editor = lib.mkOption {
    type = lib.types.str;
    description = "The default editor to use.";
    default = "vim";
  };

  config = cfg: {
    environment.systemPackages = with pkgs; [
      # basics
      git
      bash

      # file handing
      zip
      unzip
      vim
      nano
      jq # format json
      exiftool

      # network
      wget
      curl
      bind
      traceroute
      speedtest-cli
      static-web-server # http server
      nmap
      inetutils
      net-tools

      # hardware resources
      htop
      btop
      usbutils
      xsensors
      ncdu

      # nix
      cachix
    ];

    environment.variables = {
      EDITOR = cfg.editor;
    };

    environment.shellAliases = {
      edit = cfg.editor;
      serve = "static-web-server --port 3000 --root ./";
      cls = "echo 'Are you stupid? I hate Windows and CMD!'";
    };

    programs.fish.shellAliases = {
      # requires a fish-only alias because the used syntax is only compatible with fish
      encrypt-as-zip = "zip --encrypt $argv[1].zip $argv[1]";
    };

    programs.fish.shellAbbrs = {
      cdconfig = "cd ${flakePath}";
      edit-config = "edit ${flakePath}";

      cddownloads = "cd /home/${username}/Downloads";
      edit-notes = "edit ~/Downloads/tmp.md";

      cdprojects = "cd /home/${username}/Desktop/projects";
    };
  };
}
