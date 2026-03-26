{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.version;
  homeCfg = config.tsssni.home;
  shellCfg = config.tsssni.shell.shell;
  user = {
    name = "tsssni";
    email = "dingyongyu2002@foxmail.com";
  };
in
{
  options.tsssni.devel.version = {
    enable = lib.mkEnableOption "tsssni.devel.version";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      git = lib.optionalAttrs (!homeCfg.standalone) {
        enable = true;
        signing.format = null;
        settings = {
          inherit user;
          credential.helper = "store";
          rebase.pull = "rebase";
        };
      };
      jujutsu = {
        enable = true;
        settings = {
          inherit user;
        };
      };
      direnv = {
        enable = true;
        enableNushellIntegration = shellCfg.enable;
        nix-direnv.enable = true;
      };
    };
  };
}
