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
      rev = "6f72210";
      hash = "sha256-jT0W8JV1buuXc7sZ2S67LEHE93tA3T0zdw9CJRHhfmo=";
    };
    dependencies = [ pkgs.vimPlugins.lush-nvim ];
  };
}
