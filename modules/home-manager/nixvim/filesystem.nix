{
  pkgs,
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
          "<Leader>b" = "buffers";
          "<Leader>d" = "diagnostics_document";
          "<Leader>f" = "files";
          "<Leader>s" = "live_grep";
          "<Leader>h" = "helptags";
          "<Leader>j" = "jumps";
          "<Leader>r" = "lsp_references";
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
            normal = "<Leader>a";
            terminal = "<C-a>";
          };
        };
      };
      neogit.enable = true;
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
        key = "<Leader>g";
        action = ":Neogit<CR>";
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
        key = "<C-Esc>";
        action = ":bd!<CR>";
      }
    ];
  };

  home.packages = with pkgs; [
    claude-code
  ];
}
