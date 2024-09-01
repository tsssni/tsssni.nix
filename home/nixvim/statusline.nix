{ pkgs, tsssni-pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
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
              icon = "";
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
                  if lualine_scope_name == nil then
                    lualine_scope_name = "Not in any scope"
                  end

                  local clients = vim.lsp.get_active_clients()
                  for _, client in ipairs(clients) do
                    if not client.server_capabilities.documentSymbolProvider then
                      lualine_scope_name = "Not in any scope"
                      return lualine_scope_name
                    end
                  end

                  local params = { textDocument = vim.lsp.util.make_text_document_params() }
                  vim.lsp.buf_request_all(0, "textDocument/documentSymbol", params, function(response, err)
                    local no_scope = true
                    local is_scope = function(kind)
                      local available_symbol_kind = { 2, 3, 4, 5, 6, 9, 10, 11, 12, 23 }
                      for _, scope_kind in pairs(available_symbol_kind) do
                        if kind == scope_kind then
                          return true
                        end
                      end
                      return false
                    end

                    local row = vim.api.nvim_win_get_cursor(0)[1]
                    local scope_start = 0
                    local scope_end = 1145141919810

                    if response then
                      for client_id, result in pairs(response) do
                        if result and result.result then
                          for _, symbol in ipairs(result.result) do
                            if is_scope(symbol.kind) then
                              local symbol_start = symbol.range["start"].line
                              local symbol_end = symbol.range["end"].line
                              if true
                                and symbol_start >= scope_start 
                                and symbol_end <= scope_end
                                and symbol_start <= row 
                                and symbol_end >= row
                              then
                                no_scope = false
                                lualine_scope_name = symbol.name
                                scope_start = symbol_start
                                scope_end = symbol_end
                              end
                            end
                          end
                        end
                      end
                    end

                    if no_scope then
                      lualine_scope_name = "Not in any scope"
                    end
                  end)
                  
                  return lualine_scope_name
                end
              '';
              icon = "󰊕 ->";
              color.fg = "#85b4ff";
            }
            {
              name = "branch";
              color.fg = "#a8a8ff";
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
      gitsigns.enable = true;
    };

    extraPlugins = []
      ++ (with pkgs.vimPlugins; [ nvim-web-devicons ]) 
      ++ (with tsssni-pkgs.vimPlugins; [ incline-nvim ]);

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
            local group_name = { removed = 'Delete', changed = 'Change', added = 'Add' }
            for name, icon in pairs(icons) do
              if tonumber(signs[name]) and signs[name] > 0 then
                table.insert(labels, { icon .. ' ' .. signs[name] .. ' ', group = 'Diff' .. group_name[name] })
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
