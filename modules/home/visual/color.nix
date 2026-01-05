{
  config,
  lib,
  ...
}:
let
  cfg = config.tsssni.visual.color;
  colorOption =
    default:
    lib.mkOption {
      type = (with lib.types; nullOr str);
      inherit default;
    };
  foreground = "#bebad9";
  background = "#303446";
  palette = [
    "#1a1730"
    "#f26dab"
    "#8ec794"
    "#e5c890"
    "#8499d9"
    "#a78dd4"
    "#7dd5d5"
    "#bebad9"
    "#645e8c"
    "#ff8d7c"
    "#a8e5af"
    "#f5dba8"
    "#a0b4e5"
    "#c0a8e8"
    "#9fe5e5"
    "#d5d1e6"
  ];
  colorList = [
    "black"
    "red"
    "green"
    "yellow"
    "blue"
    "magenta"
    "cyan"
    "white"
    "lightBlack"
    "lightRed"
    "lightGreen"
    "lightYellow"
    "lightBlue"
    "lightMagenta"
    "lightCyan"
    "lightWhite"
  ];
in
{
  options.tsssni.visual.color = {
    enable = lib.mkEnableOption "tsssni.visual.color";
    palette = lib.mkOption {
      type = with lib.types; listOf str;
      default = palette;
    };
    foreground = colorOption foreground;
    background = colorOption background;
  }
  // builtins.listToAttrs (
    map (x: {
      name = x;
      value = colorOption null;
    }) colorList
  );

  config = lib.mkIf cfg.enable {
    tsssni.visual.color = builtins.listToAttrs (
      lib.imap0 (i: x: {
        name = x;
        value = lib.mkDefault (builtins.elemAt cfg.palette i);
      }) colorList
    );
  };
}
