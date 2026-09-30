inputs: final: prev: {
  claude-desktop = inputs.claude-desktop-extra.packages.${prev.system}.default.overrideAttrs (old: {
    # nixpkgs' electron crashes (SIGILL) on startup unless CHROME_DEVEL_SANDBOX is set,
    # which its own wrapper does but the claude-desktop wrapper doesn't
    postFixup =
      (old.postFixup or "")
      + ''
        wrapProgram $out/bin/claude-desktop \
          --set-default CHROME_DEVEL_SANDBOX $out/lib/claude-desktop/chrome-sandbox
      '';
  });
}
