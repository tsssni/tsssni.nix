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
      settings = {
        user = {
            name = "tsssni";
            email = "dingyongyu2002@foxmail.com";
        };
        credential.helper = "store";
        rebase.pull = "rebase";
      };
    };
    programs.lazygit = {
      enable = true;
    };
  };
}
