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
      barbar = {
        enable = true;
        keymaps = {
          previous.key = "<C-h>";
          next.key = "<C-l>";
          closeBuffersLeft.key = "<C-z>";
          closeBuffersRight.key = "<C-c>";
          closeAllButCurrent.key = "<C-x>";
        };
        settings = {
          exclude_name = [ "" ];
          icons.button = false;
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
          "<Leader>r" = "lsp_references";
          "<Leader>s" = "resume";
          "<Leader>v" = "git_hunks";
        };
        settings =
          let
            toggle = {
              "ctrl-g".__raw = "require('fzf-lua').actions.toggle_ignore";
              "ctrl-h".__raw = "require('fzf-lua').actions.toggle_hidden";
            };
            copy = {
              "ctrl-y".__raw = ''
                function(selected)
                  vim.fn.setreg('+', table.concat(selected, '\n'))
                end
              '';
            };
          in
          {
            keymap = {
              builtin = {
                "<C-u>" = "preview-page-up";
                "<C-d>" = "preview-page-down";
              };
            };
            fzf_colors = true;
            fzf_opts = {
              "--cycle" = true;
              "--multi" = true;
            };
            winopts.wrap = true;
            actions.files = {
              "__unkeyed_1" = true;
            }
            // copy;
            files.actions = toggle;
            grep = {
              rg_opts = "--column -n --no-heading --color=always -S -U -M=4096 -e";
              actions = toggle;
            };
          };
      };
      mini-icons = {
        enable = true;
        mockDevIcons = true;
      };
      auto-session.enable = true;
    };

    dependencies = {
      fzf.enable = false;
      git.enable = false;
    };

    globals = {
      mapleader = " ";
      localmapleader = " ";
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
        key = "<C-q>";
        action = ":bd!<CR>";
      }
      {
        mode = "n";
        key = "<C-/>";
        action.__raw = ''
          function()
            vim.cmd('nohlsearch')
            vim.fn.setreg('/', "")
            local ok, msgs = pcall(require, 'vim._core.ui2.messages')
            if ok then msgs.msg_clear() end
          end
        '';
      }
    ];
  };

  programs = {
    fzf.enable = true;
    ripgrep.enable = true;
  };
}
