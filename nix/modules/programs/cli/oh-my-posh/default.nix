{lib, ...}: {
  options = {
    profile = lib.mkOption {
      type = lib.types.enum ["cli" "gui"];
      default = "cli";
      description = ''
        Select which oh-my-posh configuration to use.
        Determines the JSON file (<value>.json).
      '';
    };
  };

  config = cfg: {
    hm.programs.oh-my-posh = {
      enable = true;
      enableFishIntegration = true;
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./${cfg.profile}.json));
    };
  };
}
