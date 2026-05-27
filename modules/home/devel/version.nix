{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.version;
  homeCfg = config.tsssni.home;
  shellCfg = config.tsssni.intef.shell;
  hasUser = cfg.name != null && cfg.email != null;
  user = {
    inherit (cfg) name email;
  };
in
{
  options.tsssni.devel.version = {
    enable = lib.mkEnableOption "tsssni.devel.version";
    name = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    email = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    tsssni.intef.shell.environmentVariables = {
      PROMPT_COMMAND = lib.hm.nushell.mkNushellInline "{||}";
      PROMPT_COMMAND_RIGHT = lib.hm.nushell.mkNushellInline ''
        {||
          let cache = $"($env.TMPDIR? | default "/tmp")/nu-version-($env.PWD | hash md5)"
          let entries = [".jj/repo/op_heads/heads" ".git/HEAD" ".git/index" "." ]
          let mtimes = $entries | each {|entry| try { ls -D $entry | get 0.modified }}
          let stale = try { (open --raw $cache | from nuon | get mtimes) != $mtimes } catch { true }
          let bookmark = if not $stale { "" } else { try {
            jj log -r '@ | @-' --no-graph -T 'local_bookmarks' err> /dev/null | str trim
          } catch { try {
            git rev-parse --abbrev-ref HEAD err> /dev/null | str trim
          } catch { "" }}}
          let version = if not $stale {
            open --raw $cache | from nuon | get render
          } else if $bookmark == "" {
            {render: "", mtimes: $mtimes} | to nuon | save -f $cache
            ""
          } else {
            let unstaged = (git diff --quiet | complete).exit_code != 0
            let staged = (git diff --cached --quiet | complete).exit_code != 0
            let markers = [(if $unstaged { $"(ansi light_red)~(ansi reset)" }) (if $staged { $"(ansi light_green)+(ansi reset)" })] | compact | str join " "
            let suffix = if $markers != "" { $" ($markers)" } else { "" }
            let render = $"(ansi light_blue)($bookmark)(ansi reset)($suffix) "
            {render: $render, mtimes: $mtimes} | to nuon | save -f $cache
            $render
          }
          let code = if $env.LAST_EXIT_CODE != 0 { $"(ansi red)($env.LAST_EXIT_CODE)(ansi reset) " } else { "" }
          $"($version)($code)"
        }
      '';
    };

    programs = {
      git = lib.mkIf (!homeCfg.standalone) {
        enable = true;
        signing.format = null;
        settings = {
          credential.helper = "store";
          rebase.pull = "rebase";
          user = lib.mkIf hasUser user;
        };
      };
      jujutsu = lib.mkIf (!homeCfg.standalone) {
        enable = true;
        settings.user = lib.mkIf hasUser user;
      };
      direnv = {
        enable = true;
        enableNushellIntegration = shellCfg.enable;
        nix-direnv.enable = true;
      };
    };

    home.packages = with pkgs; [
      gh
      nurl
    ];
  };
}
