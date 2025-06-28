{
  pkgs,
  ...
}:
let
  build = pkgs.vimUtils.buildVimPlugin;
in
with pkgs;
{
  cyyber-nvim = build {
    name = "cyyber.nvim";
    src = fetchFromGitHub {
      owner = "tsssni";
      repo = "cyyber.nvim";
      rev = "c6c461d";
      hash = "sha256-K48bijNRjHgtYrceJfrT8b3TXuRQDTW6OilXqoYUJbk=";
    };
    dependencies = [ pkgs.vimPlugins.lush-nvim ];
  };
  eldritch-nvim = build {
    name = "eldritch.nvim";
    src = fetchFromGitHub {
      owner = "eldritch-theme";
      repo = "eldritch.nvim";
      rev = "adedead";
      hash = "sha256-i0TG8yVRi1AZQS8ZOEXchYRxgU8UCNoHCmhOV8rBmX4=";
    };
  };
  incline-nvim = build {
    name = "incline";
    src = fetchFromGitHub {
      owner = "b0o";
      repo = "incline.nvim";
      rev = "0eb5b7f";
      hash = "sha256-EeNvFa+Zrqgnp3Wtcwi4EdOgtnlZf9a68xPcYrH545k=";
    };
  };
}
