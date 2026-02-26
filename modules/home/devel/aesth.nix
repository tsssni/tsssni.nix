{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.devel.aesth;
  nixvimConfig = config.programs.nixvim;
in
{
  options.tsssni.devel.aesth = {
    enable = lib.mkEnableOption "tsssni.visual.aesth";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      blender
      gimp3
      (unityhub.override {
        # without available editor unity refuse to generate csproj
        extraLibs = (pkgs: [ nixvimConfig.build.package ]);
      })
    ];
  };
}
