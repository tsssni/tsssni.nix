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
          basedpyright.enable = true;
          clangd = {
            enable = true;
            cmd = [
              "clangd"
              "--header-insertion=never"
              "--function-arg-placeholders=false"
            ];
          };
          cmake.enable = true;
          glsl_analyzer.enable = true;
          lua_ls.enable = true;
          nixd = {
            enable = true;
            settings.formatting.command = [ "nixfmt" ];
          };
          slangd = {
            enable = true;
            package = pkgs.shader-slang;
          };
          ts_ls.enable = true;
          tinymist = {
            enable = true;
            settings = {
              exportPdf = "onSave";
              formatterMode = "typstyle";
            };
          };
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

    filetype.extension = {
      slang = "shaderslang";
      hlsl = "hlsl";
      hlsli = "hlsl";
      glsl = "glsl";
      vert = "glsl";
      tesc = "glsl";
      tese = "glsl";
      geom = "glsl";
      frag = "glsl";
      comp = "glsl";
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
