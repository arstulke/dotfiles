inputs: final: prev: {
  fastpotify = inputs.fastpotify.packages.${prev.system}.default;
}
