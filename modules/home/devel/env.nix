{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.env;
  shellCfg = config.tsssni.shell.shell;
in
{
  options.tsssni.devel.env = {
    enable = lib.mkEnableOption "tsssni.devel.env";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableNushellIntegration = shellCfg.enable;
      nix-direnv.enable = true;
    };
  };
}
