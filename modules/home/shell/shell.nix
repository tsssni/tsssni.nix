{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.shell.shell;
  homeCfg = config.tsssni.home;
  visualCfg = config.tsssni.visual;
in
{
  options.tsssni.shell.shell = {
    enable = lib.mkEnableOption "tsssni.shell.shell";
  };

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
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
      }
      // lib.optionalAttrs visualCfg.gui.enable {
        XCURSOR_SIZE = 24;
        XCURSOR_THEME = "macOS";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        XDG_SESSION_TYPE = "wayland";
      };
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

    programs = {
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
      zellij.enable = true;
    };
  };
}
