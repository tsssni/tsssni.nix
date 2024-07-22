{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.dashboard = {
      enable = true;
      settings.config = {
        header = [          
          "  _________   ______       ______       ______       ___   __       ________     " 
          " /________/\\ /_____/\\     /_____/\\     /_____/\\     /__/\\ /__/\\    /_______/\\    "
          " \\__.::.__\\/ \\::::_\\/_    \\::::_\\/_    \\::::_\\/_    \\::\\_\\\\  \\ \\   \\__.::._\\/    " 
          "    \\::\\ \\    \\:\\/___/\\    \\:\\/___/\\    \\:\\/___/\\    \\:. `-\\  \\ \\     \\::\\ \\     "
          "     \\::\\ \\    \\_::._\\:\\    \\_::._\\:\\    \\_::._\\:\\    \\:. _    \\ \\    _\\::\\ \\__  " 
          "      \\::\\ \\     /____\\:\\     /____\\:\\     /____\\:\\    \\. \\`-\\  \\ \\  /__\\::\\__/\\ "
          "       \\__\\/     \\_____\\/     \\_____\\/     \\_____\\/     \\__\\/ \\__\\/  \\________\\/ " 
          "                                                                                 "
        ];
        packages.enable = false;
        shortcut = [
          {
            desc = "[  tsssni ]";
            group = "DashboardShortCut";
          }
        ];
        footer = [
          "                                                "
          "何気ない日常で、ほんの少しの奇跡を見つける物語。"
          "                                                "
        ];
      };
    };
    extraPlugins = with pkgs; [
      vimPlugins.lush-nvim
      vimPlugins.hologram-nvim
      (vimUtils.buildVimPlugin {
        name = "tsssni-theme";
        src = fetchFromGitHub {
          owner = "tsssni";
          repo = "tsssni-theme.nvim";
          rev = "4731cf5";
          hash = "sha256-V9LkOxoh1cJwn4t00c1a0/MkfFUuwIezypkiW46AIPo=";
        };
      })
    ];
    colorscheme = "tsssni-theme";
  };
}
