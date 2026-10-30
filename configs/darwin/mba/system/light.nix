{ pkgs, ... }:
{
  tsssni.infra.light = with pkgs; {
    enable = true;
    replace = {
      boost189 = boost189_1;
      gettext = gettext-runtime;
      ncurses = ncurses-alacritty;
    };
  };
}
