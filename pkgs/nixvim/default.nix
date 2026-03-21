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
      rev = "fff8d85";
      hash = "sha256-EopEGk3QV6svocKIq4AdQl5eOrJ4kcoazH1emZtzkiY=";
    };
    dependencies = [ pkgs.vimPlugins.lush-nvim ];
  };
}
