return {
  'neovim/nvim-lspconfig',
  config = function()
    local lsp_config = require'lspconfig'
    lsp_config.clangd.setup{}
    lsp_config.cmake.setup{}
    lsp_config.lua_ls.setup{}
    lsp_config.nil_ls.setup{}
    lsp_config.texlab.setup{}
    lsp_config.tsserver.setup{}

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
    vim.keymap.set('n', 'gR', vim.lsp.buf.rename, {})
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
    vim.keymap.set('n', 'gf', vim.lsp.buf.format, {})
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, {})
  end
}
