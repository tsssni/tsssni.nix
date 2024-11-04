{ ... }:
{
  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+t" = "new_tab";
      "ctrl+q" = "close_tab";
      "ctrl+j" = "previous_tab";
      "ctrl+k" = "next_tab";
    };
    settings = {
      # font
      font_family = "MonaspiceNe Nerd Font";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # tab
      allow_remote_control = "yes";

      # window
      confirm_os_window_close = 0;

      # basic colors
      foreground = "#f5c1e9";
      background = "#120b10";
      selection_foreground = "none";
      selection_background = "#1a0b63";

      # cursor colors
      cursor = "#ff0055";
      cursor_text_color = "#f8f8ff";

      # url underline color when hovering with mouse
      url_color = "#bef743";

      # kitty window border colors and terminal bell colors
      active_border_color = "#ff0055";
      inactive_border_color = "#120b10";
      bell_border_color = "#ff0055";
      visual_bell_color = "none";

      # tab bar colors
      active_tab_foreground = "#120b10";
      active_tab_background = "#ff0055";
      inactive_tab_foreground = "#ff0055";
      inactive_tab_background = "#120b10";
      tab_bar_background  = "#120b10";
      tab_bar_margin_color = "#120b10";

      # basic 16 colors

      # black
      color0 = "#333333";
      color8 = "#777777";

      # red
      color1 = "#ff0055";
      color9 = "#ff6699";

      # green
      color2 = "#61a702";
      color10 = "#bef743";

      # yellow
      color3 = "#fccb2e";
      color11 = "#ffff40";

      # blue
      color4  = "#4685ea";
      color12 = "#85b4ff";

      # magenta
      color5  = "#8b4efc";
      color13 = "#a8a8ff";

      # cyan
      color6 = "#00ffc8";
      color14 = "#7ff5f5";

      # white
      color7  = "#aaaabb";
      color15 = "#f8f8ff";
    };
  };
}
