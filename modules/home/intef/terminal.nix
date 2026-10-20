{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.tsssni.intef.terminal;
  homeCfg = config.tsssni.home;
  literatureCfg = config.tsssni.devel.literal;
  colorCfg = literatureCfg.color;
  fontCfg = literatureCfg.font;
  normal = lib.intersectAttrs bright colorCfg;
  bright =
    colorCfg
    |> lib.filterAttrs (n: _: lib.hasPrefix "light" n)
    |> lib.mapAttrs' (n: lib.nameValuePair (n |> lib.removePrefix "light" |> lib.toLower));
in
{
  options.tsssni.intef.terminal = {
    enable = lib.mkEnableOption "tsssni.intef.terminal";
    terminfo = lib.mkEnableOption "tsssni.intef.terminal.terminfo";
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.optional cfg.terminfo pkgs.alacritty.terminfo;

    programs.alacritty = lib.mkIf (!cfg.terminfo) {
      enable = true;
      package = homeCfg.install pkgs.alacritty;
      settings = {
        window = {
          decorations = "None";
          option_as_alt = "Both";
          startup_mode = if pkgs.stdenv.hostPlatform.isDarwin then "Maximized" else "Windowed";
        };
        keyboard.bindings = [
          {
            key = "C";
            mods = "Super";
            action = "Copy";
          }
          {
            key = "V";
            mods = "Super";
            action = "Paste";
          }
          {
            key = "Equals";
            mods = "Control";
            action = "IncreaseFontSize";
          }
          {
            key = "Minus";
            mods = "Control";
            action = "DecreaseFontSize";
          }
        ];
        font = lib.mkIf literatureCfg.enable {
          normal.family = fontCfg.monoFont.name;
          size = fontCfg.monoFont.size;
        };
        colors = lib.mkIf literatureCfg.enable {
          primary = {
            inherit (colorCfg) foreground background;
          };
          inherit normal bright;
          selection.background = colorCfg.lightBlack;
          cursor = {
            cursor = colorCfg.lightBlack;
            text = colorCfg.lightWhite;
          };
        };
      };
    };
  };
}
