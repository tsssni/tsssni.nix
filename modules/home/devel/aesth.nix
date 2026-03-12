{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.devel.aesth;
  intelliCfg = config.tsssni.devel.intelli;
  nixvimCfg = config.programs.nixvim;
in
{
  options.tsssni.devel.aesth = {
    enable = lib.mkEnableOption "tsssni.devel.aesth";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      blender
      gimp3
      (unityhub.override {
        # without available editor unity refuse to generate csproj
        extraLibs = (
          pkgs:
          [
            nixvimCfg.build.package
          ]
          ++ (lib.optionals intelliCfg.enable (
            with pkgs;
            [
              claude-code
              python314
              uv
              xterm
            ]
          ))
        );
      })
    ];
  };
}
