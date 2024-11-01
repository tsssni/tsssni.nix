{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # fonts
      (nerdfonts.override { fonts = [ "Monaspace" ]; })
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      # for gtk
      dconf
    ];

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
    };
  };

  gtk = {
    enable = true;

    theme = {
      name = "Fluent";
      package = pkgs.fluent-gtk-theme;
    };

    iconTheme = {
      name = "Fluent";
      package = pkgs.fluent-icon-theme;
    };

    font.name = "MonaspiceNe Nerd Font Medium 12";

    gtk2.extraConfig = "gtk-application-prefer-dark-theme = 1";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  qt = {
    enable = true;
  };
}
