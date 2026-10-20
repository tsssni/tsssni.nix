{ pkgs, ... }:
{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    stateVersion = "24.11";
  };

  tsssni = {
    home.standalone = true;
    devel = {
      intelli.enable = true;
      literal = {
        enable = true;
        font.monoFont.size = 19;
        input.type = "ibus";
      };
      version.enable = true;
      wired = {
        enable = true;
        firefox = true;
      };
    };
    infra.light = {
      enable = true;
      replace = with pkgs; {
        boost189 = boost189_1;
        gettext = gettext-runtime;
        glibc = glibc-utf8;
        icu = icu-en;
        ncurses = ncurses-alacritty;
      };
    };
    intef = {
      shell.enable = true;
      terminal.enable = true;
    };
    nixvim.enable = true;
  };
}
