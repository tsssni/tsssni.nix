{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.intelli;
  model =
    name: m:
    pkgs.writeScriptBin name (lib.hm.nushell.mkNushellInline ''
      #!${pkgs.nushell}/bin/nu
      def --wrapped main [...args] {
        let api_key = open "${m.apiKeyPath}" | str trim
        with-env {
          ANTHROPIC_BASE_URL: "${m.baseUrl}"
          ANTHROPIC_AUTH_TOKEN: $api_key
          ANTHROPIC_MODEL: "${m.model}"
          ANTHROPIC_DEFAULT_OPUS_MODEL: "${m.model}"
          ANTHROPIC_DEFAULT_SONNET_MODEL: "${m.model}"
          ANTHROPIC_DEFAULT_HAIKU_MODEL: "${m.fastModel}"
          CLAUDE_CODE_SUBAGENT_MODEL: "${m.fastModel}"
        } { claude ...$args }
      }
    '').expr;
in
{
  options.tsssni.devel.intelli = {
    enable = lib.mkEnableOption "tsssni.devel.intelli";
    models = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              baseUrl = lib.mkOption { type = lib.types.str; };
              model = lib.mkOption { type = lib.types.str; };
              fastModel = lib.mkOption { type = lib.types.str; };
              apiKeyPath = lib.mkOption {
                type = lib.types.str;
                default = "${config.xdg.configHome}/${name}/api-key";
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      settings = {
        theme = "dark-ansi";
        editorMode = "vim";
        alwaysThinkingEnabled = true;
        showThinkingSummaries = true;
      };
    };

    home.packages = lib.mapAttrsToList model cfg.models;

    tsssni.devel.intelli.models.deepseek = lib.mkDefault {
      baseUrl = "https://api.deepseek.com/anthropic";
      model = "deepseek-v4-pro[1m]";
      fastModel = "deepseek-v4-flash";
    };
  };
}
