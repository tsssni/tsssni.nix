{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni.nixvim;
  mkInjection = parent: attr: language:
    let
      str = "(indented_string_expression (string_fragment) @injection.content)";
      wrap = inner: ''
        (binding
          attrpath: (attrpath attr: (identifier) @_parent)
          expression: (attrset_expression
            (binding_set
              ${inner}))
          (#eq? @_parent "${parent}")
          (#eq? @_attr "${attr}")
          (#set! injection.language "${language}"))
      '';
    in
    # parent = { attr(.foo)? = ''...''; }
    wrap ''(binding
              attrpath: (attrpath attr: (identifier) @_attr)
              expression: ${str})''
    # parent = { attr(.foo)? = let/+/... ''...''; }
    + wrap ''(binding
              attrpath: (attrpath attr: (identifier) @_attr)
              expression: (_ ${str}))''
    # parent = { attr = { ... = ''...''; }; }
    + wrap ''(binding
              attrpath: (attrpath attr: (identifier) @_attr)
              expression: (attrset_expression
                (binding_set
                  (binding
                    expression: ${str}))))''
    # parent = { attr = { ... = let/+/... ''...''; }; }
    + wrap ''(binding
              attrpath: (attrpath attr: (identifier) @_attr)
              expression: (attrset_expression
                (binding_set
                  (binding
                    expression: (_ ${str})))))'';

in
{
  programs.nixvim = lib.mkIf cfg.enable {
    lsp = {
      keymaps = [
        {
          key = "gr";
          lspBufAction = "rename";
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
        package = null;
        config = {
          nixpkgs.expr = "import <nixpkgs> { }";
          formattings.command = [ "nixfmt" ];
        };
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

    extraFiles."after/queries/nix/injections.scm".text = ''
      ; extends
      ${mkInjection "zellij" "extraConfig" "kdl"}
      ${mkInjection "zellij" "layouts" "kdl"}
      ${mkInjection "nushell" "configFile" "nu"}
      ${mkInjection "nushell" "envFile" "nu"}
    '';

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
      nixd
      nixfmt
    ];
  };
}
