{
  config,
  pkgs,
  hostname,
  ...
}: {
  networking.networkmanager.enable = true;
  networking.hostName = hostname;

  hm.programs.fish.functions.wifi-connect = {
    argumentNames = ["ssid"];
    body = ''
      argparse 'h/hidden' -- $argv
      or return

      if not set -q ssid
        echo "usage: wifi-connect <ssid> [--hidden|-h]" >&2
        return 1
      end

      read -s -P "WiFi password: " password

      if set -q _flag_hidden
        echo "Connecting to hidden network '$ssid'..."
        nmcli device wifi rescan ssid "$ssid"
        nmcli device wifi list
        nmcli device wifi connect "$ssid" password "$password" hidden yes
      else
        echo "Connecting to exposed network '$ssid'..."
        nmcli device wifi connect "$ssid" password "$password"
      end
    '';
  };
}
