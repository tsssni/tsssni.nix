{ pkgs, tsssni, ... }:
{
  programs.nixvim = {
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
            lualine_a = [ "" ];
            lualine_b = [ "" ];
            lualine_c = [
              {
                __unkeyed-1 = "mode";
                icon = "󱄅";
                color.fg = "#37f499";
              }
              {
                __unkeyed-1 = "location";
                icon = "";
                color.fg = "#04d1f9";
              }
              {
                __unkeyed-1 = "progress";
                color.fg = "#04d1f9";
              }
            ];
            lualine_x = [
              {
                __unkeyed-1.__raw = ''
                  function()
                    local clients = vim.lsp.get_clients{ bufnr = 0, }

                    local active_clients = '['
                    if next(clients) then
                      for _, client in ipairs(clients) do
                        active_clients = active_clients .. ' ' .. client.name;
                      end
                    end
                    active_clients = active_clients .. ' ]'
                    return active_clients
                  end
                '';
                icon = "⚙ LSP:";
                color.fg = "#f1fc79";
              }
              {
                __unkeyed-1.__raw = ''
                  function()
                    local empty_scope_name = '{ }'
                    if lualine_scope_name == nil then
                      lualine_scope_name = empty_scope_name
                      return lualine_scope_name
                    end

                    local clients = vim.lsp.get_clients{ bufnr = 0, }
                    if not next(clients) then
                      lualine_scope_name = empty_scope_name
                      return lualine_scope_name
                    end

                    local has_symbol_provider = false;
                    for _, client in ipairs(clients) do
                      if client.server_capabilities.documentSymbolProvider then
                        has_symbol_provider = true
                      end
                    end

                    if not has_symbol_provider then
                      lualine_scope_name = empty_scope_name
                      return lualine_scope_name
                    end

                    local params = { textDocument = vim.lsp.util.make_text_document_params() }
                    vim.lsp.buf_request_all(0, 'textDocument/documentSymbol', params, function(result)
                      local no_scope = true
                      local is_scope = function(kind)
                        local available_symbol_kind = { 
                          2, -- module
                          3, -- namespace
                          5, -- class
                          6, -- method
                          8, -- field
                          9, -- constructor
                          10, -- enum
                          11, -- interface
                          12, -- function
                          23, -- struct
                        }
                        for _, scope_kind in pairs(available_symbol_kind) do
                          if kind == scope_kind then
                            return true
                          end
                        end
                        return false
                      end

                      local cursor = vim.api.nvim_win_get_cursor(0)
                      local row = cursor[1] - 1;
                      local col = cursor[2];
                      print(row, col)
                      local scope_start = 0
                      local scope_end = 1145141919810

                      if not result then
                        lualine_scope_name = empty_scope_name
                        return
                      end

                      local process_symbol
                      process_symbol = function (symbol)
                        if is_scope(symbol.kind) then
                          local symbol_start_line = symbol.range['start'].line
                          local symbol_start_col = symbol.range['start'].character
                          local symbol_end_line = symbol.range['end'].line
                          local symbol_end_col = symbol.range['end'].character

                          print(symbol.name, symbol_start_line, symbol_end_line)

                          local row_in_symbol = function ()
                            local inline = symbol_start_line <= row and symbol_end_line >= row
                            local start_right = row ~= symbol_start_line or col >= symbol_start_col
                            local end_left = row ~= symbol_end_line or col <= symbol_end_col
                            print(inline, start_right, end_left)
                            return inline and start_right and end_left
                          end

                          local symbol_in_scope = function ()
                            return symbol_start_line >= scope_start and symbol_end_line <= scope_end
                          end

                          if row_in_symbol() and symbol_in_scope() then
                            no_scope = false
                            lualine_scope_name = '{ ' .. symbol.name .. ' }'
                            scope_start = symbol_start_line
                            scope_end = symbol_end_line

                            if (symbol.children) then
                              for _, child in ipairs(symbol.children) do
                                process_symbol(child)
                              end
                            end
                          end
                        end
                      end

                      for client_id, client_result in pairs(result) do
                        if client_result and client_result.result then
                          for _, symbol in ipairs(client_result.result) do
                            process_symbol(symbol)
                          end
                        end
                      end

                      if no_scope then
                        lualine_scope_name = empty_scope_name
                      end
                    end)
                    
                    return lualine_scope_name
                  end   
                '';
                icon = "󰊕 ->";
                color.fg = "#f265b5";
              }
              {
                __unkeyed-1 = "branch";
                color.fg = "#a48cf2";
              }
            ];
            lualine_y = [ "" ];
            lualine_z = [ "" ];
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
      gitsigns.enable = true;
    };

    extraPlugins = []
      ++ (with pkgs.vimPlugins; [ nvim-web-devicons ]) 
      ++ (with tsssni.pkgs.vimPlugins; [ incline-nvim ]);

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
                table.insert(labels, { icon .. ' ' .. signs[name] .. ' ', group = 'GitSigns' .. group_name[name] })
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
