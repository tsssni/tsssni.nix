{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.nixvim;
in
{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;
      settings = {
        direction = "float";
        open_mapping = "[[<C-`>]]";
      };
    };
    keymaps = lib.mkIf cfg.enable [
      {
        mode = "t";
        key = "<C-Esc>";
        action = "<C-\\><C-n>";
      }
    ];
  };
}
