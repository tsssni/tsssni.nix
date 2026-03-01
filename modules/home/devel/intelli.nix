{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.devel.intelli;
in
{
  options.tsssni.devel.intelli = {
    enable = lib.mkEnableOption "tsssni.devel.intelli";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      claude-code
      github-copilot-cli
    ];
  };
}
