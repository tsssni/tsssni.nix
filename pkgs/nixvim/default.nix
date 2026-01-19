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
      rev = "6aef23c";
      hash = "sha256-uzlYQaGZgE+0paKSwPmKcEuY47hQYOOBWFtHeubHBGI=";
    };
    dependencies = [ pkgs.vimPlugins.lush-nvim ];
  };
}
