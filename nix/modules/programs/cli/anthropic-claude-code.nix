{
  pkgs,
  lib,
  inputs,
  ...
}: let
  # Prints the usage limits of the Claude subscription as shown by `/usage` in the Claude Code CLI.
  # It uses the same (undocumented) endpoint and the OAuth login of the Claude Code CLI.
  # Output: "<remaining-session-time> (<session-usage> %)" in the first line, details in the following lines.
  claudeUsage = pkgs.writeShellApplication {
    name = "claude-usage";
    runtimeInputs = with pkgs; [coreutils curl jq];
    text = ''
      credentials="''${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.credentials.json"
      if ! token=$(jq -er '.claudeAiOauth.accessToken' "$credentials" 2>/dev/null); then
        echo "Not logged in to Claude Code (run 'claude' to log in)" >&2
        exit 1
      fi

      if ! usage=$(curl -fsS --max-time 10 https://api.anthropic.com/api/oauth/usage \
        -H "Authorization: Bearer $token" \
        -H "anthropic-beta: oauth-2025-04-20"); then
        echo "Failed to query usage (an expired login is refreshed by running 'claude')" >&2
        exit 1
      fi

      # $1: ISO timestamp -> remaining time like "2h 05m" or "45m"
      remaining() {
        if [ -z "$1" ]; then
          echo "--"
          return
        fi
        secs=$(($(date -d "$1" +%s) - $(date +%s)))
        if [ "$secs" -lt 0 ]; then
          secs=0
        fi
        if [ "$secs" -ge 3600 ]; then
          printf '%dh %02dm\n' $((secs / 3600)) $((secs % 3600 / 60))
        else
          printf '%dm\n' $((secs / 60))
        fi
      }

      # $1: name of the limit -> "<usage-in-percent>|<resets-at>"
      limit() {
        jq -r --arg limit "$1" '.[$limit] // empty | "\(.utilization // 0 | round)|\(.resets_at // "")"' <<<"$usage"
      }

      IFS='|' read -r session_usage session_resets_at <<<"$(limit five_hour)"
      echo "$(remaining "$session_resets_at") (''${session_usage:-0} %)"
      if [ -n "$session_resets_at" ]; then
        echo "Session: ''${session_usage} % (resets $(date -d "$session_resets_at" '+%H:%M'))"
      else
        echo "Session: not started"
      fi

      for weekly in "seven_day|Week" "seven_day_sonnet|Week (Sonnet)" "seven_day_opus|Week (Opus)"; do
        IFS='|' read -r name label <<<"$weekly"
        IFS='|' read -r weekly_usage weekly_resets_at <<<"$(limit "$name")"
        if [ -n "$weekly_usage" ]; then
          echo "$label: $weekly_usage %''${weekly_resets_at:+ (resets $(date -d "$weekly_resets_at" '+%a %H:%M'))}"
        fi
      done
    '';
  };
in {
  environment.systemPackages = with pkgs; [
    unstable.claude-code

    # usage monitor
    claudeUsage # in CLI (in gnome statusbar via command-indicators below)

    # addons
    unstable.rtk
  ];

  # usage monitor in gnome statusbar
  modules.desktop.gnome.command-indicators.claude-usage = {
    command = "${claudeUsage}/bin/claude-usage";
    interval = 60;
  };

  # initializing rtk
  system.userActivationScripts.initRtkForClaudeCode = ''
    ${pkgs.unstable.rtk}/bin/rtk init -g
  '';
}
