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
  cyyber-nvim = build {
    name = "cyyber.nvim";
    src = fetchFromGitHub {
      owner = "tsssni";
      repo = "cyyber.nvim";
      rev = "a80df07";
      hash = "sha256-rWueDIcT1NLoPW0aqKXLLcbybs7ndLN3zSmk5ocSU5s=";
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
}
