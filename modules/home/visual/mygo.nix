{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.tsssni.visual.mygo;
in
{
  options.tsssni.visual.mygo = {
    enable = lib.mkEnableOption "tsssni.visual.mygo";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [ ]
      ++ [
        go-musicfox
      ]
      ++ lib.optionals stdenv.isLinux [
        bluez
        alsa-utils
      ];
  };
}
