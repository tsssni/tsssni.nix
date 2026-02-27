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
      rev = "7aeb21b";
      hash = "sha256-dsy+BbsEPXabRu2+jfR2Wx7D/Q9QZ6kn9/P6uaVSUMk=";
    };
    dependencies = [ pkgs.vimPlugins.lush-nvim ];
  };
}
