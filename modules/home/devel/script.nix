{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.devel.script;
  python = pkgs.python3.withPackages (ps: with ps; [ mlx ]);
in
{
  options.tsssni.devel.script = {
    enable = lib.mkEnableOption "tsssni.devel.script";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ python ];
  };
}
