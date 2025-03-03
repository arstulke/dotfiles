{ pkgs, lib, ... }:

{

  #################################
  ############ PACKAGES ###########
  #################################
  environment.systemPackages = with pkgs; [
  ];

  #################################
  ###### PROGRAMS / SERVICES ######
  #################################
  programs.fish.enable = true;

  #################################
  ########## HOME-MANAGER #########
  #################################
  home-manager.users = let
    users = [ "arne" "root" ];
  in lib.genAttrs users (username: {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        # Disable greeting
        set fish_greeting
      '';
    };

    programs.oh-my-posh = {
      enable = true;
      enableFishIntegration = true;
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./oh-my-posh-config.json));
    };

    programs.atuin = {
      enable = true;
      enableFishIntegration = true;
    };
    home.file.".config/atuin/config.toml".text = ''
      enter_accept = true

      filter_mode = "workspace"
      workspaces = true
    '';
  });

  users.defaultUserShell = pkgs.fish;
}
