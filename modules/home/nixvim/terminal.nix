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
    plugins = {
      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          float_opts = {
            width.__raw = "math.floor(vim.o.columns * 0.85)";
            height.__raw = "math.floor(vim.o.lines * 0.85)";
          };
        };
      };
    };

    keymaps = lib.mkIf cfg.enable [
      {
        mode = "t";
        key = "<C-Esc>";
        action = "<C-\\><C-n>";
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-t>";
        action = "<cmd>1ToggleTerm<CR>";
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-a>";
        action = "<cmd>2ToggleTerm<CR>";
      }
    ];
  };
}
