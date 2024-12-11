{ config, pkgs, lib, nix-vscode-extensions, ... }:

{
  # TODO run container in rootless mode
  virtualisation.oci-containers.containers."noco" = {
    image = "nocodb/nocodb:latest";
    ports = [ "8080:8080" ];
    volumes = [
      "/home/arne/Desktop/nocodb:/usr/app/data"
    ];
  };

  # create nocodb dir
  system.activationScripts.createNocodbDir = "mkdir -p /home/arne/Desktop/nocodb";
}
