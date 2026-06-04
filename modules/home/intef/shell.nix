{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.intef.shell;
  homeCfg = config.tsssni.home;

  scriptsPath = "${pkgs.nu_scripts}/share/nu_scripts";
  homeEnvs = {
    PATH = lib.hm.nushell.mkNushellInline ''($env.PATH | prepend $"($env.HOME)/.nix-profile/bin" | uniq)'';
  };
  darwinEnvs = {
    PATH = lib.hm.nushell.mkNushellInline ''($env.PATH | prepend $"/run/current-system/sw/bin/" | prepend $"/etc/profiles/per-user/${config.home.username}/bin" | uniq)'';
  };
  completions =
    arr:
    arr
    |> map (x: "source ${scriptsPath}/custom-completions/${x}/${x}-completions.nu")
    |> lib.concatStringsSep "\n";

  zjstatus = ''
    zjstatus location="file://${pkgs.zellijPlugins.zjstatus}/bin/zjstatus.wasm" {
        format_left "{tabs}"
        tab_normal "#[fg=7]π"
        tab_active "#[fg=7,bold]λ"
    }
  '';
  multiplex = lib.hm.nushell.mkNushellInline ''
    def "multiplex spawn" [path?: directory] {
      let target = if $path == null {
        pwd
      } else {
        $path | path expand
      }
      let name = $target | hash md5 | str substring 0..7
      cd $target
      try { zellij d $name }
      zellij a --create $name
    }

    def "multiplex kill" [path?: directory] {
      let target = if $path == null { pwd } else { $path | path expand }
      let name = $target | hash md5 | str substring 0..7
      zellij d $name --force
    }

    def "multiplex clear" [] {
      zellij ka --yes
      zellij da --yes
    }
  '';

  nixSmallLogo = pkgs.writeText "nix-small.txt" ''
    $1  \\  $2\\ //
    $1 ==\\__$2\\/ $1//
    $2   //   \\$1//
    $2==//     $1//==
    $2 //$1\\$2___$1//
    $2// $1/\\  $2\\==
    $1  // \\  $2\\
  '';
in
{
  options.tsssni.intef.shell = {
    enable = lib.mkEnableOption "tsssni.intef.shell";
    environmentVariables = lib.mkOption {
      type = lib.types.attrsOf lib.hm.types.nushellValue;
      default = { };
    };
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
          table.missing_value_symbol = "";
        };
        environmentVariables =
          { }
          // (lib.optionalAttrs homeCfg.standalone homeEnvs)
          // (lib.optionalAttrs pkgs.stdenv.isDarwin darwinEnvs)
          // cfg.environmentVariables;
        configFile.text =
          (completions [
            "git"
            "jj"
            "nix"
            "zellij"
          ])
          + "\n\n"
          + multiplex.expr;
      };

      zellij = {
        enable = true;
        settings = {
          theme = "ansi";
          show_startup_tips = false;
          default_mode = "Normal";
          default_layout = "copilot";
          default_shell = "nu";
          mouse_mode = true;
          advanced_mouse_actions = false;
        };
        extraConfig = ''
          keybinds clear-defaults=true {
              shared_except "entersearch" "renametab" "renamepane" {
                  bind "Alt j" { GoToNextTab; }
                  bind "Alt k" { GoToPreviousTab; }
                  bind "Alt f" { ToggleFloatingPanes; }
                  bind "Alt n" { NewPane; }
                  bind "Alt p" { SwitchToMode "Pane"; }
                  bind "Alt t" { SwitchToMode "Tab"; }
                  bind "Alt r" { SwitchToMode "Resize"; }
                  bind "Alt m" { SwitchToMode "Move"; }
                  bind "Alt s" { SwitchToMode "Scroll"; }
                  bind "Alt o" { SwitchToMode "Session"; }
                  bind "Alt q" { Detach; }
              }
              shared_except "normal" "entersearch" "renametab" "renamepane" {
                  bind "Esc" { SwitchToMode "Normal"; }
              }
              pane {
                  bind "h" "Left" { MoveFocus "Left"; }
                  bind "l" "Right" { MoveFocus "Right"; }
                  bind "j" "Down" { MoveFocus "Down"; }
                  bind "k" "Up" { MoveFocus "Up"; }
                  bind "p" { SwitchFocus; }
                  bind "n" { NewPane; SwitchToMode "Normal"; }
                  bind "d" { NewPane "Down"; SwitchToMode "Normal"; }
                  bind "r" { NewPane "Right"; SwitchToMode "Normal"; }
                  bind "x" { CloseFocus; SwitchToMode "Normal"; }
                  bind "f" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
                  bind "z" { TogglePaneFrames; SwitchToMode "Normal"; }
                  bind "w" { ToggleFloatingPanes; SwitchToMode "Normal"; }
                  bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "Normal"; }
                  bind "c" { SwitchToMode "RenamePane"; PaneNameInput 0; }
              }
              tab {
                  bind "h" "Left" "k" "Up" { GoToPreviousTab; }
                  bind "l" "Right" "j" "Down" { GoToNextTab; }
                  bind "n" { NewTab; SwitchToMode "Normal"; }
                  bind "x" { CloseTab; SwitchToMode "Normal"; }
                  bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
                  bind "s" { ToggleActiveSyncTab; }
                  bind "b" { BreakPane; SwitchToMode "Normal"; }
                  bind "Tab" { ToggleTab; }
              }
              resize {
                  bind "h" "Left" { Resize "Increase Left"; }
                  bind "j" "Down" { Resize "Increase Down"; }
                  bind "k" "Up" { Resize "Increase Up"; }
                  bind "l" "Right" { Resize "Increase Right"; }
                  bind "H" { Resize "Decrease Left"; }
                  bind "J" { Resize "Decrease Down"; }
                  bind "K" { Resize "Decrease Up"; }
                  bind "L" { Resize "Decrease Right"; }
                  bind "=" "+" { Resize "Increase"; }
                  bind "-" { Resize "Decrease"; }
              }
              move {
                  bind "n" "Tab" { MovePane; }
                  bind "p" { MovePaneBackwards; }
                  bind "h" "Left" { MovePane "Left"; }
                  bind "j" "Down" { MovePane "Down"; }
                  bind "k" "Up" { MovePane "Up"; }
                  bind "l" "Right" { MovePane "Right"; }
              }
              scroll {
                  bind "e" { EditScrollback; SwitchToMode "Normal"; }
                  bind "s" { SwitchToMode "EnterSearch"; SearchInput 0; }
                  bind "j" "Down" { ScrollDown; }
                  bind "k" "Up" { ScrollUp; }
                  bind "d" { HalfPageScrollDown; }
                  bind "u" { HalfPageScrollUp; }
                  bind "f" "PageDown" { PageScrollDown; }
                  bind "b" "PageUp" { PageScrollUp; }
              }
              search {
                  bind "j" "Down" { ScrollDown; }
                  bind "k" "Up" { ScrollUp; }
                  bind "d" { HalfPageScrollDown; }
                  bind "u" { HalfPageScrollUp; }
                  bind "f" "PageDown" { PageScrollDown; }
                  bind "b" "PageUp" { PageScrollUp; }
                  bind "n" { Search "down"; }
                  bind "p" { Search "up"; }
                  bind "c" { SearchToggleOption "CaseSensitivity"; }
                  bind "w" { SearchToggleOption "Wrap"; }
                  bind "o" { SearchToggleOption "WholeWord"; }
              }
              entersearch {
                  bind "Esc" { SwitchToMode "Scroll"; }
                  bind "Enter" { SwitchToMode "Search"; }
              }
              renametab {
                  bind "Esc" { UndoRenameTab; SwitchToMode "Tab"; }
              }
              renamepane {
                  bind "Esc" { UndoRenamePane; SwitchToMode "Pane"; }
              }
              session {
                  bind "d" { Detach; }
                  bind "w" {
                      LaunchOrFocusPlugin "session-manager" {
                          floating true
                          move_to_focused_tab true
                      };
                      SwitchToMode "Normal";
                  }
              }
          }

          plugins {
              ${zjstatus}
          }
        '';
        layouts.copilot = ''
          layout split_direction="Vertical" {
              pane size=1 borderless=true {
                  plugin location="zjstatus"
              }
              pane
          }
        '';
      };

      fastfetch = {
        enable = true;
        package = with pkgs; if homeCfg.standalone then null else fastfetch;
        settings = {
          logo = {
            type = "file";
            source = "${nixSmallLogo}";
            color = {
              "1" = "light_blue";
              "2" = "light_cyan";
            };
          };
          modules = [
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
              keyColor = "magenta";
            }
            {
              type = "kernel";
              format = "{sysname} {release}";
              key = " 核";
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
