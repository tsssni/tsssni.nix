{
  pkgs,
  ...
}:
let
  build = pkgs.vimUtils.buildVimPlugin;
in
with pkgs;
{
  plana-nvim = build {
    name = "plana.nvim";
    src = fetchFromGitHub {
      owner = "tsssni";
      repo = "plana.nvim";
      rev = "7e1d445";
      hash = "sha256-5A78Kfu0OTpSwBd0PCZ33ddlSsA27U+6mvCfvW1z1dQ=";
    };
    dependencies = [ pkgs.vimPlugins.lush-nvim ];
  };
}
