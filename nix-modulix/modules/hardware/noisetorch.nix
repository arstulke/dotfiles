{ pkgs, ... }:

{
  programs.noisetorch.enable = true;

  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    helvum
  ];

  systemd.user.services.noisetorch = {
    enable = true;
    description = "Start NoiseTorch at login";
    after = ["pipewire.service" "default.target"];

    serviceConfig = {
      ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i";
      Restart = "always";
      Environment = "DISPLAY=:0";
    };

    wantedBy = ["default.target"];
  };
}
