{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    unstable.gemini-cli

    # addons
    unstable.rtk
  ];

  system.userActivationScripts.initRtkForGemini = ''
    ${pkgs.unstable.rtk}/bin/rtk init -g --gemini
    ${pkgs.gnused}/bin/sed -i '1s|.*|#!/usr/bin/env bash|' /home/${username}/.gemini/hooks/rtk-hook-gemini.sh
  '';
}
