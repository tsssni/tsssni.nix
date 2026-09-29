{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.aesth;
in
{
  options.tsssni.devel.aesth.enable = lib.mkEnableOption "tsssni.devel.aesth";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      go-musicfox
      tev
    ];

    programs.mpv = {
      enable = true;
      package = pkgs.mpv.override { youtubeSupport = false; };
      config.hwdec = "auto-safe";
    };

    xdg.mimeApps = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
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
