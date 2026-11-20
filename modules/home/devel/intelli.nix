{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.intelli;
  homeCfg = config.tsssni.home;
  nu = if homeCfg.standalone then "nu" else lib.getExe pkgs.nushell;

  mutate =
    agent: target:
    let
      cfg = config.programs.${agent};
      file = pkgs.writeText "${agent}-settings.json" (builtins.toJSON cfg.settings);
      path = lib.escapeShellArg "${config.home.homeDirectory}/${target}";
    in
    ''
      run ${nu} --no-config-file ${./config/mutate.nu} ${file} ${path}
    ''
    |> lib.hm.dag.entryAfter [ "linkGeneration" ]
    |> lib.mkForce
    |> lib.mkIf cfg.enable;
in
{
  options.tsssni.devel.intelli = {
    enable = lib.mkEnableOption "intelligence configuration";
    antigravity = lib.mkEnableOption "antigravity configuration";
    codex = lib.mkEnableOption "codex configuration";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      antigravity-cli = {
        enable = cfg.antigravity;
        package = homeCfg.install pkgs.antigravity-cli;
        mutableSettings = true;
        settings = {
          colorScheme = "terminal";
          editorMode = "vim";
          notifications = false;
          showFeedbackSurvey = false;
        };
      };
      codex = {
        enable = cfg.codex;
        package = homeCfg.install pkgs.codex;
        mutableSettings = true;
        settings = {
          model_auto_compact_token_limit = 900000;
          model_context_window = 1000000;
          model_reasoning_effort = "high";
          model_reasoning_summary = "auto";
          feedback.enabled = false;
          tui = {
            theme = "ansi";
            vim_mode_default = true;
            notifications = false;
          };
        };
      };
    };

    home.activation = {
      antigravitySettings = mutate "antigravity-cli" ".gemini/antigravity-cli/settings.json";
      codexMutableSettings = mutate "codex" ".codex/config.toml";
    };
  };
}
