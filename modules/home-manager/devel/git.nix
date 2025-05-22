{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.git;
in
{
  options.tsssni.devel.git = {
    enable = lib.mkEnableOption "tsssni.devel.git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "tsssni";
      userEmail = "dingyongyu2002@foxmail.com";
      extraConfig = {
        credential.helper = "store";
        rebase.pull = "rebase";
      };
    };
  };
}
