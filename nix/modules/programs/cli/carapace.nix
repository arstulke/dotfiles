{ pkgs, lib, ... }:

{
    hm.programs.carapace = {
        enable = true;
        enableFishIntegration = true;
    };
}
