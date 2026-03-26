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
          let
            pathSetup =
              if homeCfg.standalone then
                ''$env.PATH = ($env.PATH | prepend $"($env.HOME)/.nix-profile/bin")''
              else if pkgs.stdenv.isDarwin then
                ''$env.PATH = ($env.PATH | prepend $"/run/current-system/sw/bin/" | prepend $"/etc/profiles/per-user/${config.home.username}/bin")''
              else
                "";
          in
          ''
            $env.PROMPT_COMMAND = {||}
            $env.PROMPT_COMMAND_RIGHT = {||
              let exit_code = if $env.LAST_EXIT_CODE != 0 { $"(ansi red)($env.LAST_EXIT_CODE)(ansi reset) " } else { "" }
              let git = try {
                let branch = (git rev-parse --abbrev-ref HEAD err> /dev/null | str trim)
                let unstaged = (git diff --quiet | complete).exit_code != 0
                let staged = (git diff --cached --quiet | complete).exit_code != 0
                let markers = [(if $unstaged { $"(ansi light_red)~(ansi reset)" }) (if $staged { $"(ansi light_green)+(ansi reset)" })] | compact | str join " "
                let suffix = if $markers != "" { $" ($markers)" } else { "" }
                $"(ansi light_blue)($branch)(ansi reset)($suffix) "
              } catch { "" }
              $"($git)($exit_code)"
            }
            ${pathSetup}
          '';
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
          default_mode = "Normal";
          default_layout = "copilot";
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
                  bind "Alt q" { Quit; }
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
        '';
        layouts.copilot =
          let
            zjstatusPlugin = ''plugin location="file://${pkgs.zjstatus}/bin/zjstatus.wasm"'';
          in
          ''
            layout split_direction="Vertical" {
                pane size=1 borderless=true {
                    ${zjstatusPlugin} {
                        format_left "{tabs}"
                        tab_normal "#[fg=7]π"
                        tab_active "#[fg=7,bold]λ"
                    }
                }
                pane
            }
          '';
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
