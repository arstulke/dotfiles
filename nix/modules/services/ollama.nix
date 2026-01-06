{
  pkgs,
  inputs,
  ...
}: {
  services.ollama = {
    enable = false;
    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_NUM_PARALLEL = "2";
      OLLAMA_MAX_LOADED_MODELS = "2";
      OLLAMA_NOHISTORY = "1";
    };
  };
}
