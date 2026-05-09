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
    produce = lib.mkEnableOption "tsssni.devel.aesth.produce";
    consume = lib.mkEnableOption "tsssni.devel.aesth.consume";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      lib.optionals cfg.produce [
        blender
        gimp3
        (unityhub.override {
          # without available editor unity nvim plugin refuse to generate csproj
          extraLibs = (pkgs: [ nixvimCfg.build.package ]);
        })
      ]
      ++ lib.optionals cfg.consume [
        go-musicfox
        tev
      ];

    programs.mpv = lib.mkIf cfg.consume { enable = true; };

    xdg.mimeApps = lib.mkIf (cfg.consume && pkgs.stdenv.isLinux) {
      enable = true;
      defaultApplications =
        let
          tevApp = "tev.desktop";
          mpvApp = "mpv.desktop";
          tevTypes = [
            "image/bmp"
            "image/exr"
            "image/hdr"
            "image/jpeg"
            "image/jxl"
            "image/png"
            "image/tag"
          ];
          mpvTypes = [
            "video/avi"
            "video/flv"
            "video/mkv"
            "video/mov"
            "video/mpeg"
            "video/mp4"
            "video/quicktime"
            "video/webm"
            "video/wmv"
            "video/x-matroska"
            "video/x-msvideo"
          ];
          mapTypes =
            app: types:
            builtins.listToAttrs (
              map (t: {
                name = t;
                value = app;
              }) types
            );
        in
        { } // mapTypes tevApp tevTypes // mapTypes mpvApp mpvTypes;
    };
  };
}
