{ ... }:
{
    programs.nixvim.keymaps = [
      {
        mode = "n";
        key = "<A-t>";
        action = ":terminal<CR>";
      }
      {
        mode = "t";
        key = "<C-Esc>";
        action = "<C-\\><C-n>";
      }
    ];
  }
