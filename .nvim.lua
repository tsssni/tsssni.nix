vim.lsp.config('nixd', {
  settings = {
    nixd = {
      options = {
        nixos = {
          expr = '(builtins.getFlake (toString ./.)).nixosConfigurations.msi.options',
        },
        darwin = {
          expr = '(builtins.getFlake (toString ./.)).darwinConfigurations.mba.options',
        },
        home = {
          expr = '(builtins.getFlake (toString ./.)).homeConfigurations.user.options',
        },
      },
    },
  },
})
vim.lsp.enable('nixd')
vim.o.shiftwidth = 2
vim.o.tabstop = 2
