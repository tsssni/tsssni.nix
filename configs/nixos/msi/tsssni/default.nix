{ ... }:
{
  home = {
    username = "tsssni";
    homeDirectory = "/home/tsssni";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  tsssni = {
    devel = {
      aesth.enable = true;
      intelli.enable = true;
      script.enable = true;
      version.enable = true;
    };
    nixvim.enable = true;
    shell = {
      fetch.enable = true;
      shell.enable = true;
      terminal.enable = true;
    };
    visual = {
      ime = {
        enable = true;
        type = "fcitx5";
      };
      media.enable = true;
      theme = {
        gui.enable = true;
        tui.enable = true;
      };
      window = {
        enable = true;
        monitors = {
          HDMI-A-1 = {
            scale = 1.5;
            width = 3840;
            height = 2160;
            wallpaper = ./config/niri/wallpaper/chainsaw.jpg;
          };
        };
        shell.enable = true;
        sunset.enable = true;
        file.enable = true;
      };
    };
    wired = {
      browser.enable = true;
      cloud.enable = true;
      ssh.enable = true;
    };
  };
}
