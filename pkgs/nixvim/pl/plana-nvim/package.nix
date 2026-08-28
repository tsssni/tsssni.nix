{
  vimPlugins,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "plana.nvim";
  version = "0-unstable-2026-04-25";
  src = ./.;
  dependencies = [ vimPlugins.lush-nvim ];
}
