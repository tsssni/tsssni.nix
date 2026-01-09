vim.lsp.config('nixd', {
  settings = {
    nixd = {
        options = {
            nixos = {
                expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.msi.options',
            },
            darwin = {
                expr = '(builtins.getFlake ("git+file://" + toString ./.)).darwinConfigurations.mba.options',
            },
            home = {
                expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations.user.options',
            },
        },
    },
  },
})
vim.lsp.enable('nixd')
