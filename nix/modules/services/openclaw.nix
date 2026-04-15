{pkgs, ...}: {
  services.openclaw = {
    enable = true;
    openFirewall = false;
    package = pkgs.unstable.openclaw;

    # Model provider
    modelProvider = "openrouter";
    modelApiKeyFile = "/run/secrets/openrouter-api-key";

    # Telegram bot
    telegram = {
      enable = true;
      tokenFile = "/run/secrets/telegram-bot-token";
    };

    # Tool security (defaults shown — you don't need to set these)
    toolSecurity = "allowlist";
    toolAllowlist = [
      "read"
      "write"
      "edit"
      "web_search"
      "web_fetch"
      "message"
      "tts"
    ];
  };
}
