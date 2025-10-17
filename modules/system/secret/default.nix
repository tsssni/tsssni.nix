{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.secret;
in
{
  options.tsssni.secret = {
    enable = lib.mkEnableOption "tsssni.secret";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      agenix
    ];
  };
}
