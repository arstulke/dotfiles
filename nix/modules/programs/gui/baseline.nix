{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # general
    gradia
    vlc
    pinta
    firefox
    drawio
    libreoffice
    keepassxc

    # pdf
    pdfarranger
    xournalpp
    kdePackages.okular

    # technical
    wireshark
    gparted
    unstable.bruno
    unstable.bruno-cli
  ];

  # Install firefox
  programs.firefox.enable = true;
}
