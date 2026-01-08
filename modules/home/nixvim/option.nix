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

    opts = {
      autoindent = true;
      autoread = true;
      background = "dark";
      backup = false;
      cmdheight = 1;
      completeopt = "menu,menuone,noselect,noinsert";
      cursorline = true;
      encoding = "utf-8";
      expandtab = true;
      exrc = true;
      fileencoding = "utf-8";
      fileformats = "unix";
      foldclose = "all";
      hidden = true;
      hlsearch = false;
      incsearch = true;
      laststatus = 0;
      list = true;
      listchars = "tab:>·,space:·";
      mouse = "a";
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
      termguicolors = true;
      updatetime = 300;
      whichwrap = "<,>,[,]";
      wildmenu = true;
      wrap = false;
      writebackup = false;
    };
  };
}
