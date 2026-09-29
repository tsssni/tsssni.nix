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

    globals = {
      editorconfig = false;
      loaded_gzip = 1;
      loaded_man = 1;
      loaded_matchit = 1;
      loaded_matchparen = 1;
      loaded_netrwPlugin = 1;
      loaded_nvim_net_plugin = 1;
      loaded_remote_plugins = 1;
      loaded_shada_plugin = 1;
      loaded_spellfile_plugin = 1;
      loaded_tarPlugin = 1;
      loaded_tutor_mode_plugin = 1;
      loaded_zipPlugin = 1;
    };

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
      termguicolors = true;
      timeoutlen = 500;
      updatetime = 300;
      whichwrap = "<,>,[,]";
      wrap = false;
      writebackup = false;
    };
  };
}
