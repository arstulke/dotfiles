{
  pkgs,
  lib,
  inputs,
  ...
}: {
  options.prepVsCode = lib.mkOption {
    type = lib.types.bool;
    description = "Whether to preparing VS code to use the AWS CLI and session-manager-plugin.";
    default = false;
  };

  config = cfg: {
    environment.systemPackages = with pkgs; [
      unstable.awscli2
      ssm-session-manager-plugin
    ];

    programs.fish.shellAbbrs = {
      edit-aws = "edit ~/.aws/";
    };

    # define symlink in settings of VS code extension "amazonwebservices.aws-toolkit-vscode" to sessionmanagerplugin binary
    hm.home.file.".config/Code/User/globalStorage/amazonwebservices.aws-toolkit-vscode/tools/Amazon/sessionmanagerplugin" = lib.mkIf cfg.prepVsCode {
      source = "${pkgs.ssm-session-manager-plugin}";
    };
  };
}
