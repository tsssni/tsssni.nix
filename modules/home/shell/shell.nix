{
  pkgs,
  lib,
  config,
  tsssni,
  ...
}:
let
  cfg = config.tsssni.shell.shell;
  homeCfg = config.tsssni.home;
  guiCfg = config.tsssni.visual.gui;
in
{
  options.tsssni.shell.shell = {
    enable = lib.mkEnableOption "tsssni.shell.shell";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nushell = {
        enable = true;
        package = if homeCfg.standalone then null else pkgs.nushell;
        settings = {
          show_banner = false;
          edit_mode = "vi";
          buffer_editor = "nvim";
          cursor_shape = {
            vi_normal = "block";
            vi_insert = "line";
          };
          completions.algorithm = "prefix";
          use_kitty_protocol = true;
          table.missing_value_symbol = "";
        };
        environmentVariables = {
          EDITOR = "nvim";
          NIX_PATH = "nixpkgs=${tsssni.inputs.nixpkgs}";
        }
        // lib.optionalAttrs guiCfg.enable {
          XCURSOR_SIZE = 24;
          XCURSOR_THEME = "macOS";
          QT_QPA_PLATFORMTHEME = "qt5ct";
          XDG_SESSION_TYPE = "wayland";
        };
        envFile.text =
          if homeCfg.standalone then
            ''
              $env.PATH = ($env.PATH | prepend $"($env.HOME)/.nix-profile/bin")
            ''
          else if pkgs.stdenv.isDarwin then
            ''
              $env.PATH = ($env.PATH | prepend $"/run/current-system/sw/bin/" | prepend $"/etc/profiles/per-user/${config.home.username}/bin")
            ''
          else
            "";
        configFile.text =
          let
            nuScriptsPath = "${pkgs.nu_scripts}/share/nu_scripts/";
            completionsPath = nuScriptsPath + "custom-completions/";
          in
          ''
            source ${completionsPath}/git/git-completions.nu
            source ${completionsPath}/nix/nix-completions.nu
          '';
      };
      zellij = {
        enable = true;
        settings = {
          theme = "ansi";
          show_startup_tips = false;
          default_mode = "Locked";
        };
      };
      btop = {
        enable = true;
        package = if homeCfg.standalone then null else pkgs.btop;
        settings = {
          color_theme = "TTY";
          theme_background = false;
          vim_keys = true;
          update_ms = 2000;
        };
      };
    };
  };
}
