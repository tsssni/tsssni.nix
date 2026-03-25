{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.visual.file;
  windowCfg = config.tsssni.visual.window;
  fzfPicker = lib.getExe (pkgs.writeShellApplication {
    name = "fzf-picker";
    runtimeInputs = with pkgs; [ fzf fd coreutils ];
    text = ''
      multiple="$1"
      directory="$2"
      save="$3"
      path="$4"
      out="$5"

      if [ "$save" = "1" ]; then
        printf '%s' "$path" > "$out"
        exit
      fi

      if [ "$directory" = "1" ]; then
        fd -a --base-directory="$HOME" -td | fzf +m --prompt 'Select directory > ' > "$out"
      elif [ "$multiple" = "1" ]; then
        fd -a --base-directory="$HOME" | fzf -m --prompt 'Select files > ' > "$out"
      else
        fd -a --base-directory="$HOME" | fzf +m --prompt 'Select file > ' > "$out"
      fi
    '';
  });
  fzfWrapper = pkgs.writeShellScript "fzf-wrapper.sh" ''
    ${lib.getExe pkgs.ghostty} -e ${fzfPicker} "$@"
  '';
in
{
  options.tsssni.visual.file = {
    enable = lib.mkEnableOption "tsssni.visual.file";
  };

  config = lib.mkIf cfg.enable {
    xdg = lib.optionalAttrs windowCfg.enable {
      configFile."xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=${fzfWrapper}
      '';
      portal = {
        config.niri."org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
      };
    };
  };
}
