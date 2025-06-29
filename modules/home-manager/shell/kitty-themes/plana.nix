rec {
  # basic colors
  foreground = "#bebad9";
  background = "#303446";
  selection_foreground = "none";
  selection_background = color8;

  # basic 16 colors

  # black
  color0 = "#1a1730";
  color8 = "#645e8c";

  # red
  color1 = "#f26dab";
  color9 = "#ff8d7c";

  # green
  color2 = "#8ec794";
  color10 = "#a8e5af";

  # yellow
  color3 = "#e5c890";
  color11 = "#f5dba8";

  # blue
  color4 = "#8499d9";
  color12 = "#a0b4e5";

  # magenta
  color5 = "#a78dd4";
  color13 = "#c0a8e8";

  # cyan
  color6 = "#7dd5d5";
  color14 = "#9fe5e5";

  # white
  color7 = "#bebad9";
  color15 = "#d5d1e6";

  # cursor colors
  cursor = color8;
  cursor_text_color = color15;

  # url underline color when hovering with mouse
  url_color = color10;

  # kitty window border colors and terminal bell colors
  active_border_color = color1;
  inactive_border_color = background;
  bell_border_color = color1;
  visual_bell_color = "none";

  # tab bar colors
  active_tab_foreground = background;
  active_tab_background = color1;
  inactive_tab_foreground = color1;
  inactive_tab_background = background;
  tab_bar_background = background;
  tab_bar_margin_color = background;
}
