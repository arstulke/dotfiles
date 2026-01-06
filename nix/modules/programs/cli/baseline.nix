{
  username,
  flakePath,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # general
    git
    bash
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

    # hardware resources
    htop
    btop
    usbutils
    xsensors
  ];

  environment.shellAliases = {
    notes = "code --new-window ~/Downloads/tmp.md"; # TODO generalize for CLI only and for GUI (maybe define global alias for opening editor)
    serve = "static-web-server --port 3000 --root ./";
    encrypt-as-zip = "#!/bin/bash\\nfunction _ezip() { zip --encrypt \"\${1}.zip\" \"\$1\"; }; _ezip";

    cls = "echo 'Are you stupid? I hate Windows and CMD!'";
  };

  programs.fish.shellAbbrs = {
    edit-config = "code ${flakePath}"; # TODO generalize for CLI only and for GUI (maybe define global alias for opening editor)
    cdconfig = "cd ${flakePath}";
    cddownloads = "cd /home/${username}/Downloads";
    cdprojects = "cd /home/${username}/Desktop/projects";
  };
}
