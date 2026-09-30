{
  lib,
  pkgs,
  ...
}: let
  # Bump this (and the hash below) to upgrade
  version = "1.1.12";

  # Set to lib.fakeHash after changing the version; the failed build prints the real hash
  wheelHash = "sha256-6GDgIyuAkKKi2y8jkacoGcoAEypw3CqL+FUmJ1JMWlk=";

  mcp-shell-server = pkgs.python3Packages.buildPythonApplication {
    pname = "mcp-shell-server";
    inherit version;
    format = "wheel";

    # Pure-Python wheel from PyPI, so no build backend is needed
    src = pkgs.fetchPypi {
      pname = "mcp_shell_server";
      inherit version;
      format = "wheel";
      dist = "py3";
      python = "py3";
      hash = wheelHash;
    };

    dependencies = with pkgs.python3Packages; [mcp];

    # Tolerate a slightly older/newer `mcp` in your nixpkgs pin
    pythonRelaxDeps = ["mcp"];

    pythonImportsCheck = ["mcp_shell_server"];

    meta = {
      description = "Secure shell command execution server for the Model Context Protocol";
      homepage = "https://github.com/tumf/mcp-shell-server";
      license = lib.licenses.mit;
      mainProgram = "mcp-shell-server";
    };
  };
in {
  environment.systemPackages = [mcp-shell-server];
}
