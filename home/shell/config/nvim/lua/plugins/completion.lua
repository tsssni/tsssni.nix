return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
  },
  config = function()
    local cmp = require'cmp'
    cmp.setup{
      snippet = {
        expand = function(args)
          require'luasnip'.lsp_expand(args.body)
        end,
      },
      sources = cmp.config.sources(
        {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
        {
          { name = 'buffer' },
          { name = 'path' },
        }
      ),
      mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm{
          select = true,
          behavior = cmp.ConfirmBehavior.Replace,
        },
      }
    }
    require'luasnip.loaders.from_vscode'.lazy_load()
  end
}
