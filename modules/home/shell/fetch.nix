{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.shell.fetch;
  homeCfg = config.tsssni.home;
in
{
  options.tsssni.shell.fetch = {
    enable = lib.mkEnableOption "tsssni.shell.fetch";
  };

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      package = with pkgs; if homeCfg.standalone then null else fastfetch;
      settings = {
        logo =
          if pkgs.stdenv.isLinux then
            {
              type = "file";
              source = "${config.home.homeDirectory}/.config/fastfetch/nix-small.txt";
              color = {
                "1" = "light_blue";
                "2" = "light_cyan";
              };
            }
          else if pkgs.stdenv.isDarwin then
            {
              type = "kitty";
              source = "${config.home.homeDirectory}/.config/fastfetch/nix-darwin.png";
              width = 16;
            }
          else
            {
              type = "small";
            };

        modules =
          [ ]
          ++ lib.optionals pkgs.stdenv.isDarwin [
            {
              type = "break";
            }
          ]
          ++ [
            {
              type = "os";
              format = "{2} {9}";
              key = "󱄅 系";
              keyColor = "cyan";
            }
            {
              type = "kernel";
              format = "{1} {2}";
              key = " 核";
              keyColor = "light_yellow";
            }
            {
              type = "shell";
              format = "{3} {4}";
              key = " 壳";
              keyColor = "light_green";
            }
            {
              type = "terminal";
              format = "{5} {6}";
              key = " 端";
              keyColor = "light_magenta";
            }
            {
              type = "packages";
              format = "Nix {9}";
              key = "󰏗 包";
              keyColor = "light_blue";
            }
            {
              type = "opengl";
              format = "{5} {4}";
              key = "󰡷 图";
              keyColor = "light_cyan";
            }
            {
              type = "vulkan";
              format = "Vulkan {2}";
              key = "󰈸 火";
              keyColor = "light_white";
            }
          ];
      };
    };

    home = {
      file.".config/fastfetch" = {
        source = ./config/fastfetch;
        recursive = true;
      };
    };
  };
}
