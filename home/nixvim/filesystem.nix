{ ... }:
{
  programs = {
    nixvim = {
      plugins = {
        oil = {
          enable = true;
          settings = {
            keymaps = {
              "<CR>" = "actions.select";
              "-" = "actions.parent";
              "=" = "actions.toggle_hidden";
            };
          };
        };
        bufferline = {
          enable = true;
          alwaysShowBufferline = true;
          diagnostics = "nvim_lsp";
          numbers = "buffer_id";
          showBufferCloseIcons = false;
        };
        telescope = {
          enable = true;
          keymaps = {
            "<C-t>" = "find_files";
            "<C-g>" = "live_grep";
          };
        };
      };
      
      keymaps = [
        {
          mode = [ "n" ];
          key = "<A-f>";
          action.__raw = ''
            function()
              oil = require'oil'
              if vim.o.filetype == 'oil' then
                oil.close()
              else
                oil.open()
              end
            end
          '';
        }
        {
          mode = "n";
          key = "<C-h>";
          action = ":BufferLineCyclePrev<CR>";
        }
        {
          mode = "n";
          key = "<C-l>";
          action = ":BufferLineCycleNext<CR>";
        }
        {
          mode = "n";
          key = "<C-z>";
          action = ":BufferLineCloseLeft<CR>";
        }
        {
          mode = "n";
          key = "<C-c>";
          action = ":BufferLineCloseRight<CR>";
        }
        {
          mode = "n";
          key = "<C-x>";
          action = ":BufferLineCloseOthers<CR>";
        }
      ];
    };
    ripgrep.enable = true; # for telescope live grep
  };
}
