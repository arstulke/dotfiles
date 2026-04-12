{pkgs, ...}: {
  services.tailscale = {
    enable = true;
    disableTaildrop = true; # disable Taildrop (file sharing feature)
    disableUpstreamLogging = true; # disable uploading logs to Tailscale
  };
}
