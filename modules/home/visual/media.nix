{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.visual.media;
in
{
  options.tsssni.visual.media = {
    enable = lib.mkEnableOption "tsssni.visual.media";
  };

  config = lib.mkIf cfg.enable {
    programs.mpv.enable = true;
    home.packages = with pkgs; [
      go-musicfox
      tev
    ];
    xdg.mimeApps = lib.optionalAttrs pkgs.stdenv.isLinux {
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
