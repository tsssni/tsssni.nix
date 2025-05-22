{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.shell.shell;
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
      environmentVariables =
        {
          EDITOR = "nvim";
        }
        // lib.optionalAttrs visualCfg.gui.enable {
          XCURSOR_SIZE = 24;
          XCURSOR_THEME = "macOS";
          QT_QPA_PLATFORMTHEME = "qt5ct";
          XDG_SESSION_TYPE = "wayland";
        }
        // lib.optionalAttrs (true && visualCfg.window.enable && visualCfg.window.nvidia) {
          GBM_BACKEND = "nvidia-drm";
          LIBVA_DRIVER_NAME = "nvidia";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
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
  };
}
