{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.devel.intelli;
  homeCfg = config.tsssni.home;
  configDir =
    if config.home.preferXdgDirectories then
      "${config.xdg.configHome}/codex"
    else
      "${config.home.homeDirectory}/.codex";
  settings = pkgs.writeText "codex-settings.json" (builtins.toJSON config.programs.codex.settings);
in
{
  options.tsssni.devel.intelli = {
    enable = lib.mkEnableOption "tsssni.devel.intelli";
  };

  config = lib.mkIf cfg.enable {
    programs.codex = {
      enable = true;
      package = homeCfg.install pkgs.codex;
      mutableSettings = true;
      settings = {
        default_permissions = ":read-only";
        approval_policy = "on-request";
        model = "gpt-6-astra";
        model_auto_compact_token_limit = 900000;
        model_context_window = 1000000;
        model_reasoning_effort = "low";
        model_reasoning_summary = "auto";
        feedback.enabled = false;
        tui = {
          theme = "ansi";
          vim_mode_default = true;
          notifications = false;
        };
      };
    };

    home.activation.codexMutableSettings = lib.mkForce (
      lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        run ${lib.getExe pkgs.nushell} --no-config-file ${./config/codex.nu} \
          ${settings} ${lib.escapeShellArg "${configDir}/config.toml"}
      ''
    );
  };
}
