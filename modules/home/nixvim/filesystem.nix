{
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.nixvim;
in
{
  programs.nixvim = lib.mkIf cfg.enable {
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
          "gd" = "lsp_definitions";
          "gl" = "lsp_declarations";
          "<Leader>d" = "diagnostics_document";
          "<Leader>f" = "files";
          "<Leader>g" = "live_grep";
          "<Leader>h" = "helptags";
          "<Leader>j" = "jumps";
          "<Leader>r" = "lsp_references";
          "<Leader>s" = "resume";
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
          grep = {
            rg_opts = "--column -n --no-heading --color=always -S -U -M=4096 -e";
          };
        };
      };
      claude-code = {
        enable = true;
        settings = {
          window.position = "float";
          start_in_normal_mode = true;
          shell = {
            separator = ";";
            pushd_cmd = "use std/dirs; dirs add";
            popd_cmd = "dirs drop";
          };
          keymaps.toggle = {
            normal = "<C-a>";
            terminal = "<C-a>";
          };
        };
      };
      web-devicons.enable = true;
    };

    keymaps = [
      {
        mode = "n";
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
      {
        mode = "n";
        key = "<C-q>";
        action = ":bd!<CR>";
      }
    ];
  };

  programs = {
    ripgrep.enable = true;
    claude-code.enable = true;
  };
}
