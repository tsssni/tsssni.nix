{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      lsp-status.enable = true;
      lualine = {
        enable = true;
        globalstatus = true;
        componentSeparators = {
          left = "";
          right = "";
        };
        sectionSeparators = {
          left = "";
          right = "";
        };
        sections = {
          lualine_a = [ { name = ""; } ];
          lualine_b = [ { name = ""; }];
          lualine_c = [
            {
              name = "mode";
              icon = "";
              color.fg = "#00ffc8";
            }
            {
              name = "location";
              icon = "[-]";
              color.fg = "#7ff5f5";
            }
            {
              name = "progress";
              color.fg = "#7ff5f5";
            }
          ];
          lualine_x = [
            {
              fmt.__raw = ''
                function()
                  local msg = 'No Active Lsp'
                  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                  local clients = vim.lsp.get_active_clients()
                  if next(clients) == nil then
                    return msg
                  end
                  for _, client in ipairs(clients) do
                    local filetypes = client.config.filetypes
                    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                      return client.name
                    end
                  end
                  return msg
                end
              '';
              icon = "⚙ LSP:";
              color.fg = "#bef743";
            }
            {
              fmt.__raw = ''
                function()
                  local func = 'Not in any scope'
                  return func
                end
              '';
              icon = "󰊕 ->";
              color.fg = "#85b4ff";
            }
            {
              name = "branch";
              color.fg = "a8a8ff";
            }
          ];
          lualine_y = [ { name = ""; }];
          lualine_z = [ { name = ""; }];
        };
        inactiveSections = {
          lualine_a = [ { name = ""; }];
          lualine_b = [ { name = ""; }];
          lualine_c = [ { name = ""; }];
          lualine_x = [ { name = ""; }];
          lualine_y = [ { name = ""; }];
          lualine_z = [ { name = ""; }];
        };
      };
    };

    extraPlugins = with pkgs; [
      vimPlugins.nvim-web-devicons
      vimPlugins.gitsigns-nvim
      (vimUtils.buildVimPlugin {
        name = "incline";
        src = fetchFromGitHub {
          owner = "b0o";
          repo = "incline.nvim";
          rev = "16fc9c0";
          hash = "sha256-5DoIvIdAZV7ZgmQO2XmbM3G+nNn4tAumsShoN3rDGrs=";
        };
      })
    ];

    extraConfigLua = ''
      require'incline'.setup {
        render = function(props)
          local devicons = require 'nvim-web-devicons'
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == "" then
            filename = '[No Name]'
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)

          local function get_git_diff()
            local icons = { removed = '', changed = '', added = '' }
            local signs = vim.b[props.buf].gitsigns_status_dict
            local labels = {}
            if signs == nil then
              return labels
            end
            for name, icon in pairs(icons) do
              if tonumber(signs[name]) and signs[name] > 0 then
                table.insert(labels, { icon .. ' ' .. signs[name] .. ' ', group = 'Diff' .. name })
              end
            end
            if #labels > 0 then
              table.insert(labels, { '┊ ' })
            end
            return labels
          end

          local function get_diagnostic_label()
            local icons = { error = '', warn = '', info = '', hint = '' }
            local label = {}

            for severity, icon in pairs(icons) do
              local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
              if n > 0 then
                table.insert(label, { icon .. ' ' .. n .. ' ', group = 'DiagnosticSign' .. severity })
              end
            end
            if #label > 0 then
              table.insert(label, { '┊ ' })
            end
            return label
          end

          return {
            { get_diagnostic_label() },
            { get_git_diff() },
            { (ft_icon or "") .. ' ', guifg = ft_color, guibg = 'none' },
            { filename .. ' ', gui = vim.bo[props.buf].modified and 'bold,italic' or 'bold' },
          }
        end,
      }
    '';
  };
}
