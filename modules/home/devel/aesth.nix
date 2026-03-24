{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.devel.aesth;
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
        # without available editor unity nvim plugin refuse to generate csproj
        extraLibs = (pkgs: [ nixvimCfg.build.package ]);
      })
    ];
  };
}
