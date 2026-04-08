{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # general
    flameshot
    vlc
    pinta
    firefox
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--disable-gtk-ime"
      ];
    })
    unstable.drawio # TODO switch to stable after upgrading to NixOS 26.05
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
