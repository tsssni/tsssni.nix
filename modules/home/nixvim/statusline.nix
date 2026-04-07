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
      lualine = {
        enable = true;
        settings = {
          options = {
            globalstatus = true;
            component_separators = {
              left = "";
              right = "";
            };
            section_separators = {
              left = "";
              right = "";
            };
          };
          sections = {
            lualine_a = [
              {
                __unkeyed-1 = "lsp_status";
                icon = " LSP:";
                symbols.done = "";
              }
            ];
            lualine_b = [
              {
                __unkeyed-1 = "location";
                icon = "";
              }
              "progress"
              "searchcount"
            ];
            lualine_c = [ "" ];
            lualine_x = [ "" ];
            lualine_y = [ "" ];
            lualine_z = [
              {
                __unkeyed-1 = "navic";
                color_correction = "dynamic";
                icon = "󰊕 ->";
              }
            ];
          };
          inactiveSections = {
            lualine_a = [ "" ];
            lualine_b = [ "" ];
            lualine_c = [ "" ];
            lualine_x = [ "" ];
            lualine_y = [ "" ];
            lualine_z = [ "" ];
          };
        };
      };
      navic = {
        enable = true;
        settings = {
          lsp.auto_attach = true;
          separator = "::";
          icons.enabled = false;
        };
      };
      gitsigns.enable = true;
    };
  };
}
