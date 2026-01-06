{
  config,
  pkgs,
  flakePath,
  ...
}: {
  programs.nh = {
    enable = true;
    flake = flakePath;
  };

  environment.systemPackages = with pkgs; [nix-diff];

  environment.shellAliases = {
    build = "nh os build -H $NIX_FLAKE_DEFAULT_HOST -- --print-out-paths";
    rebuild = "nh os switch -H $NIX_FLAKE_DEFAULT_HOST";
    rebuild-test = "nh os test -H $NIX_FLAKE_DEFAULT_HOST";
    update = "nix flake update --flake ${flakePath}";
    free-nix = "sudo nix-collect-garbage --delete-older-than 30d";
  };
}
