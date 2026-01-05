{ config, pkgs, ... }:

{
  # Troubleshooting sound playback issues:
  #   Problem 1:
  #     Symptoms:
  #       - GNOME Settings speaker test freezes
  #       - `speaker-test -c 2` (from alsa-utils) hangs
  #       - Spotify fails to play audio
  #       - Browser audio playback crashes (e.g., YouTube)
  #
  #     Cause:
  #       PipeWire / WirePlumber state corruption or deadlock
  #
  #     Solution:
  #       Clear cache and restart pulseaudio and wireplumber:
  #         ```
  #         rm -rf ~/.local/state/wireplumber
  #         rm -rf ~/.cache/wireplumber
  #         systemctl --user restart pipewire wireplumber pipewire-pulse
  #         ```

  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    helvum
  ];
}
