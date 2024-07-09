{ pkgs, ... }:
{
	programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    # for telescope
    ripgrep.enable = true;
  };

  home = {
    file.".config/nvim" = {
      source = ./config/nvim;
      recursive = true;
    };
    packages = with pkgs; [
      # lsp
      clang-tools
      cmake-language-server
      lua-language-server
      nil
      nodePackages.typescript-language-server
      texlab
      # dap
      lldb
    ];
  };
}
