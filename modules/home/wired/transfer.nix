{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.wired.transfer;
in
{
  options.tsssni.wired.transfer = {
    enable = lib.mkEnableOption "tsssni.wired.transfer";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      curl
      wget
    ];
  };
}
