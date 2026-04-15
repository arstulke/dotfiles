{pkgs, ...}: {
  # Ollama for local LLM inference
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama-cpu;
    loadModels = [
      "gemma4:e2b"
    ];
    host = "0.0.0.0"; # allows access from other devices on the network
    environmentVariables = {
      OLLAMA_NOHISTORY = "1";
      OLLAMA_MAX_LOADED_MODELS = "1";
      OLLAMA_KEEP_ALIVE = "30m";
      OLLAMA_NUM_PARALLEL = "2";
    };
  };

  # Tool for finding optimal LLM models for current hardware specs
  environment.systemPackages = with pkgs; [unstable.llmfit];
}
