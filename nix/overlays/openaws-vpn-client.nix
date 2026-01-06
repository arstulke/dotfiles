inputs: final: prev: {
  openaws-vpn-client = inputs.openaws-vpn-client.defaultPackage.${prev.system};
}
