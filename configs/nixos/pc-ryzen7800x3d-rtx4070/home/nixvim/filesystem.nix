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
          settings.options = {
            always_show_bufferlinhe = true;
            diagnostics = "nvim_lsp";
            numbers = "buffer_id";
            show_buffer_close_icons = false;
          };
        };
        telescope = {
          enable = true;
          keymaps = {
            "<C-t>" = "find_files";
            "<C-g>" = "live_grep";
          };
          settings.defaults.mappings.i = {
            "<C-n>".__raw = "require('telescope.actions').cycle_history_next";
            "<C-p>".__raw = "require('telescope.actions').cycle_history_prev";
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
