{ ... }:
{
  home = {
    username = "tsssni";
    homeDirectory = "/home/tsssni";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  tsssni = {
    intef = {
      shell.enable = true;
      terminal.enable = true;
      window = {
        enable = true;
        monitors = {
          HDMI-A-1 = {
            height = 2160;
            scale = 1.5;
            wallpaper = ./config/niri/wallpaper/chainsaw.jpg;
            width = 3840;
          };
        };
        sunset.enable = true;
      };
    };
    nixvim.enable = true;
    devel = {
      aesth = {
        enable = true;
        consume = true;
        produce = true;
      };
      intelli.enable = true;
      literal = {
        enable = true;
        input.type = "fcitx5";
      };
      science.enable = true;
      version = {
        enable = true;
        name = "tsssni";
        email = "dingyongyu2002@foxmail.com";
      };
      wired = {
        enable = true;
        browser = true;
        cloud = true;
        tunnel = true;
      };
    };
  };
}
