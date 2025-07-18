{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.nixvim;
in
{
  programs = lib.mkIf cfg.enable {
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
            diagnostics = false;
            hover.enabled = false;
            indicator.stype = "none";
            numbers = "buffer_id";
            show_buffer_close_icons = false;
            show_close_icon = false;
          };
        };
        fzf-lua = {
          enable = true;
          keymaps = {
            "<Leader>b" = "buffers";
            "<Leader>c" = "git_commits";
            "<Leader>d" = "diagnostics_document";
            "<Leader>f" = "files";
            "<Leader>g" = "live_grep";
            "<Leader>h" = "helptags";
            "<Leader>j" = "jumps";
            "<Leader>m" = "git_blame";
            "<Leader>r" = "lsp_references";
            "<Leader>s" = "git_status";
            "<Leader>t" = "git_stash";
            "<Leader>u" = "resume";
          };
          settings = {
            keymap = {
              builtin = {
                "<C-u>" = "preview-page-up";
                "<C-d>" = "preview-page-down";
              };
            };
			fzf_colors = true;
            fzf_opts = {
              "--cycle" = true;
            };
            winopts.wrap = true;
          };
        };
        web-devicons.enable = true;
      };

      keymaps = [
        {
          mode = [ "n" ];
          key = "<C-f>";
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
