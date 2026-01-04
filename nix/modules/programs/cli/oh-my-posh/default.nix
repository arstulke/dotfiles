{ ... }:

{
    hm.programs.oh-my-posh = {
        enable = true;
        enableFishIntegration = true;
        settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./oh-my-posh-config.json));
    };
}
