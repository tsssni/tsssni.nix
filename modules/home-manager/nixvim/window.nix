{
  lib
, config
, ...
}:
let
  cfg = config.tsssni.nixvim;
in {
  programs.nixvim = lib.mkIf cfg.enable {
    globals = {
      mapleader = " ";
      localmapleader = " ";
    };

    keymaps = [
      {
        mode = "n";
        key = "<A-v>";
        action = ":vsp<CR>";
      }
      {
        mode = "n";
        key = "<A-s>";
        action = ":sp<CR>";
      }
      {
        mode = "n";
        key = "<A-h>";
        action = "<C-w>h";
      }
      {
        mode = "n";
        key = "<A-j>";
        action = "<C-w>j";
      }
      {
        mode = "n";
        key = "<A-k>";
        action = "<C-w>k";
      }
      {
        mode = "n";
        key = "<A-l>";
        action = "<C-w>l";
      }
      {
        mode = "n";
        key = "<A-Left>";
        action = ":vertical resize +10<CR>";
      }
      {
        mode = "n";
        key = "<A-Down>";
        action = ":resize +5<CR>";
      }
      {
        mode = "n";
        key = "<A-Up>";
        action = ":resize -5<CR>";
      }
      {
        mode ="n";
        key = "<A-Right>";
        action = ":vertical resize -10<CR>";
      }
    ];
  };
}
