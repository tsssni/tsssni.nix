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
    lsp = {
      keymaps = [
        {
          key = "gd";
          lspBufAction = "definition";
        }
        {
          key = "gD";
          lspBufAction = "declaration";
        }
        {
          key = "gr";
          lspBufAction = "rename";
        }
        {
          key = "gR";
          lspBufAction = "references";
        }
        {
          key = "gf";
          lspBufAction = "format";
        }
        {
          key = "gh";
          lspBufAction = "hover";
        }
      ];
      luaConfig.content = ''
        vim.lsp.set_log_level('OFF')
      '';
      servers.nixd = {
        enable = true;
        config.formattings.command = [ "nixfmt" ];
      };
    };
    plugins = {
      lsp.enable = true;
      treesitter = {
        enable = true;
        nixvimInjections = true;
        settings = {
          auto_install = false;
          highlight.enable = true;
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "gs";
              node_incremental = "gf";
              node_decremental = "gb";
            };
          };
          indent.enable = false;
        };
      };
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            "<Enter>" = [
              "select_and_accept"
              "fallback"
            ];
            "<C-n>" = [ "select_next" ];
            "<C-p>" = [ "select_prev" ];
            "<C-u>" = [ "scroll_documentation_up" ];
            "<C-d>" = [ "scroll_documentation_down" ];
            "<C-space>" = [
              "show"
              "show_documentation"
              "hide_documentation"
            ];
          };
          cmdline.enabled = true;
          sources = {
            default = [
              "lsp"
              "buffer"
              "path"
            ];
          };
        };
      };
      nvim-autopairs.enable = true;
    };

    diagnostic.settings = {
      virtual_lines = true;
      virtual_text = false;
      signs.text = [
        ""
        ""
        ""
        ""
      ];
    };
  };

  home = {
    packages = with pkgs; [
      lldb
      nixfmt-rfc-style
    ];
  };
}
