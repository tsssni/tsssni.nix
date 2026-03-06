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
    enable = lib.mkEnableOption "tsssni.shell.shell";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = shellCfg.enable;
    };
  };
}
