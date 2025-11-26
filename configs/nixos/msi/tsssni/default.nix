{
  pkgs,
  ...
}:
{
  home = {
    username = "tsssni";
    homeDirectory = "/home/tsssni";
    stateVersion = "24.11";
    packages = with pkgs; [
      blender
      gimp3
      hotspot
      libreoffice
      perf
      tev
    ];
  };

  programs.home-manager.enable = true;

  tsssni = {
    devel.git.enable = true;
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
      widget.enable = true;
      ime.enable = true;
      mygo.enable = true;
      mujica.enable = true;
    };
    wired = {
      browser.enable = true;
      ssh.enable = true;
    };
  };
}
