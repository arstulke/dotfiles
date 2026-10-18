inputs: final: prev: {
  spotifast = inputs.spotifast.packages.${prev.stdenv.hostPlatform.system}.default;
}
