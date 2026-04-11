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
    waylandSupport = false;
    withRuby = false;
    withPython3 = false;
    extraConfigLua = ''
      require('vim._core.ui2').enable({ msg = { targets = 'msg' } })
      vim.o.cmdheight = 0
    '';

    opts = {
      background = "dark";
      backup = false;
      completeopt = "fuzzy,menu,menuone,noselect,noinsert,popup";
      cursorline = true;
      expandtab = true;
      exrc = true;
      fileformats = "unix";
      foldclose = "all";
      hlsearch = true;
      list = true;
      listchars = "tab:>·,space:·";
      mouse = "";
      number = true;
      pumheight = 10;
      regexpengine = 2;
      report = 0;
      relativenumber = false;
      scrolloff = 8;
      shiftround = true;
      shiftwidth = 4;
      showmode = false;
      shortmess = "ctFTW";
      showtabline = 2;
      sidescrolloff = 8;
      signcolumn = "yes";
      smartindent = true;
      softtabstop = 4;
      splitbelow = true;
      splitright = true;
      swapfile = false;
      tabstop = 4;
      timeoutlen = 500;
      updatetime = 300;
      whichwrap = "<,>,[,]";
      wrap = false;
      writebackup = false;
    };
  };
}
