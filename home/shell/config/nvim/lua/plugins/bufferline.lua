return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require'bufferline'.setup{
      options = {
        diagnostics = 'nvim_lsp',
        offsets = {{
          filetype = 'NvimTree',
          text = 'File Explorer',
          highlight = 'Directory',
          text_align = 'left',
        }},
        show_buffer_close_icons = false,
        numbers = function (opts)
          return string.format('%s', opts.id)
        end
      },
    }
  end
}
