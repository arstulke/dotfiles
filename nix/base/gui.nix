{ config, pkgs, ... }:

{
  imports = [
    ./cli.nix
    ./modules/noisetorch.nix
  ];

  #################################
  ############ PACKAGES ###########
  #################################

  # List GUI packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # gnome
    dconf-editor
    gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
    gnomeExtensions.system-monitor
    gnomeExtensions.clipboard-history
    yaru-theme

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
    pdfarranger
    xournalpp
    kdePackages.okular
    drawio
    libreoffice
    
    # technical
    sublime-merge
    wireshark
    gparted
    unstable.bruno
  ];

  #################################
  ###### PROGRAMS / SERVICES ######
  #################################

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.cups-pdf.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Install firefox
  programs.firefox.enable = true;

  #################################
  ######### SHELL ALIASES #########
  #################################
  environment.shellAliases = {
    cls = "echo 'Are you stupid? I hate Windows and CMD!'";
    notes = "code --new-window ~/Downloads/tmp.md";
  };

  programs.fish.shellAbbrs = {
    cdconfig = "cd /etc/dotfiles";
    cddownloads = "cd /home/arne/Downloads";
    cdprojects = "cd /home/arne/Desktop/projects";
    edit-config = "code /etc/dotfiles";
  };

  #################################
  ########## HOME-MANAGER #########
  #################################
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.arne = {
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        disabled-extensions = [];
        enabled-extensions = [
          pkgs.gnomeExtensions.dash-to-dock.extensionUuid
          pkgs.gnomeExtensions.user-themes.extensionUuid
          pkgs.gnomeExtensions.system-monitor.extensionUuid
          pkgs.gnomeExtensions.clipboard-history.extensionUuid
        ];
      };
      "org/gnome/desktop/interface" = {
        clock-show-seconds = true;
        clock-show-weekday = true;
        show-battery-percentage = true;
        color-scheme = "prefer-dark";
        gtk-theme = "Yaru";
        cursor-theme = "Yaru";
        icon-theme = "Yaru";
      };
      "org/gnome/shell/extensions/user-theme" = {
        name = "Yaru-dark";
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = "LEFT";
        dock-fixed = true;
        extend-height = true;
        dash-max-icon-size = 42;
        click-action = "minimize-or-previews";
        multi-monitor = true;
        scroll-action = "cycle-windows";
        disable-overview-on-startup = true;
        running-indicator-style = "DOTS";
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };
      "org/gnome/mutter" = {
        edge-tiling = true;
        dynamic-workspaces = true;
        workspaces-only-on-primary = false;
        experimental-features = ["scale-monitor-framebuffer" "xwayland-native-scaling"];
      };
      "org/gtk/gtk4/settings/file-chooser" = {
        show-hidden = true;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        idle-dim = false;
        sleep-inactive-battery-timeout = 900; # 15min
        sleep-inactive-battery-type = "nothing";
        sleep-inactive-ac-timeout = 900; # 15min
        sleep-inactive-ac-type = "nothing";
        power-button-action = "interactive";
      };
      "org/gnome/desktop/session" = {
        idle-delay = 300; # 5min
      };
      "org/gnome/desktop/screensaver" = {
        lock-enabled = true;
        lock-delay = 0; # 0sec
      };
      "org/gnome/desktop/notifications" = {
        show-in-lock-screen = false;
      };

      # keybindings
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-open-terminal/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-open-filemanager/"
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
      # TODO fix flameshot
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/my-flameshot" = {
        name = "Open flameshot (screenshot tool)";
        command = "flameshot gui";
        binding = "<Primary><Shift><Alt>section";
      };
    };

    xdg.userDirs = {
      enable = true;
      # setting unnecessary user directories to home dir to prevent programs to create them
      documents = "$HOME";
      music = "$HOME";
      publicShare = "$HOME";
      templates = "$HOME";
      videos = "$HOME";
    };
  };

  system.userActivationScripts.manageDefaultDirs = ''
    mkdir -p /home/$USER/Desktop
    mkdir -p /home/$USER/Desktop/projects
  '';
}
