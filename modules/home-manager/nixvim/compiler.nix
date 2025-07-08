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
      treesitter = {
        enable = true;
        nixvimInjections = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars;
        nixGrammars = true;
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
      lsp = {
        enable = true;
        keymaps = {
          lspBuf = {
            gd = "definition";
            gD = "declaration";
            gr = "rename";
            gR = "references";
            gf = "format";
            gh = "hover";
          };
        };
        servers = {
          clangd = {
            enable = true;
            cmd = [
              "clangd"
              "--header-insertion=never"
              "--function-arg-placeholders=false"
            ];
          };
          slangd = {
            enable = true;
            package = pkgs.shader-slang;
          };
          glsl_analyzer.enable = true;
          cmake.enable = true;
          nixd = {
            enable = true;
            settings.formatting.command = [ "nixfmt" ];
          };
          lua_ls.enable = true;
          ts_ls.enable = true;
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
              "copilot"
              "buffer"
              "path"
            ];
            providers.copilot = {
              async = true;
              module = "blink-copilot";
              name = "copilot";
              score_offset = -5;
            };
          };
        };
      };
      blink-copilot.enable = true;
      copilot-lua = {
        enable = true;
        settings = {
          panel.enabled = false;
          suggestion.enabled = false;
        };
      };
      nvim-autopairs.enable = true;
    };

    filetype.extension = {
      slang = "shaderslang";
      glsl = "glsl";
      hlsl = "hlsl";
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
    file.".config/clangd" = {
      source = ./config/clangd;
      recursive = true;
    };
    packages = with pkgs; [
      copilot-language-server
      lldb
      nixfmt-rfc-style
    ];
  };
}
