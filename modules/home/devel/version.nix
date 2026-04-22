{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.version;
  homeCfg = config.tsssni.home;
  shellCfg = config.tsssni.shell.shell;
  hasUser = cfg.name != null && cfg.email != null;
  user = {
    inherit (cfg) name email;
  };
in
{
  options.tsssni.devel.version = {
    enable = lib.mkEnableOption "tsssni.devel.version";
    name = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    email = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      git = lib.optionalAttrs (!homeCfg.standalone) {
        enable = true;
        signing.format = null;
        settings = {
          credential.helper = "store";
          rebase.pull = "rebase";
        }
        // lib.optionalAttrs hasUser { inherit user; };
      };
      jujutsu = lib.optionalAttrs (!homeCfg.standalone) {
        enable = true;
        settings = lib.optionalAttrs hasUser { inherit user; };
      };
      direnv = {
        enable = true;
        enableNushellIntegration = shellCfg.enable;
        nix-direnv.enable = true;
      };
    };
  };
}
