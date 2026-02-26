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
      git.enable = true;
    };
    nixvim.enable = true;
    shell = {
      fetch.enable = true;
      prompt.enable = true;
      shell.enable = true;
      terminal.enable = true;
    };
    visual = {
      color.enable = true;
      font.enable = true;
      gui.enable = true;
      ime = {
        enable = true;
        type = "fcitx5";
      };
      media.enable = true;
      widget.enable = true;
      window = {
        enable = true;
        monitors = {
          "HDMI-A-1" = {
            scale = 1.5;
            mode = {
              width = 3840;
              height = 2160;
            };
          };
        };
        wallpaper = ./config/niri/wallpaper/plana.jpeg;
      };
    };
    wired = {
      browser.enable = true;
      cloud.enable = true;
      ssh.enable = true;
    };
  };
}
