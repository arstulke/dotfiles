inputs: final: prev: {
  spotifast = inputs.spotifast.packages.${prev.system}.default;
}
