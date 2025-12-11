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
              type = "kitty-direct";
              source = "${config.home.homeDirectory}/.config/fastfetch/nix-darwin.png";
              width = 16;
            }
          else
            {
              type = "small";
            };

        modules =
          [
            {
              type = "cpu";
              format = "{name}";
              key = " 芯";
              keyColor = "light_blue";
            }
            {
              type = "cpu";
              format = "{march}";
              key = "󰭄 构";
              keyColor = "light_magenta";
            }
            {
              type = "opengl";
              format = "{library} {slv}";
              key = "󰾲 显";
              keyColor = "light_cyan";
            }
          ]
          ++ lib.optionals pkgs.stdenv.isLinux [
            {
              type = "vulkan";
              format = "Vulkan {api-version}";
              key = "󰡷 图";
              keyColor = "blue";
            }
          ]
          ++ lib.optionals pkgs.stdenv.isDarwin [
            {
              type = "gpu";
              format = "{platform-api}";
              key = "󰡷 图";
              keyColor = "blue";
            }
          ]
          ++ [
            {
              type = "os";
              format = "{name} {codename}";
              key = "󱄅 系";
              keyColor = "light_red";
            }
            {
              type = "kernel";
              format = "{sysname} {release}";
              key = " 核";
              keyColor = "light_white";
            }
            {
              type = "shell";
              format = "{exe-name} {version}";
              key = " 壳";
              keyColor = "light_green";
            }
          ];
      };
    };

    home.file.".config/fastfetch" = {
      source = ./config/fastfetch;
      recursive = true;
    };
  };
}
