{
  config,
  lib,
  pkgs,
  ...
}: {
  options.enableFeatures = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Chrome features to enable (joined into --enable-features=...).";
    example = ["UseOzonePlatform"];
  };

  options.disableFeatures = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Chrome features to disable (joined into --disable-features=...).";
    example = ["PdfOopif"];
  };

  options.extraCommandLineArgs = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Additional command line arguments passed to Chrome.";
  };

  config = cfg: let
    enableFeatures = ["UseOzonePlatform"] ++ cfg.enableFeatures;
    disableFeatures = cfg.disableFeatures;
  in {
    environment.systemPackages = with pkgs; [
      (google-chrome.override {
        commandLineArgs =
          [
            "--ozone-platform=wayland"
            "--disable-gtk-ime"
          ]
          ++ lib.optional (enableFeatures != [])
          "--enable-features=${lib.concatStringsSep "," enableFeatures}"
          ++ lib.optional (disableFeatures != [])
          "--disable-features=${lib.concatStringsSep "," cfg.disableFeatures}"
          ++ cfg.extraCommandLineArgs;
      })
    ];
  };
}
