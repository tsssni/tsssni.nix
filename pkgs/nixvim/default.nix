{
  pkgs
, ...
}:
let
  build = pkgs.vimUtils.buildVimPlugin;
in 
with pkgs; {
  cyyber-nvim = build {
    name = "cyyber.nvim";
    src = fetchFromGitHub {
      owner = "tsssni";
      repo = "cyyber.nvim";
      rev = "b504b63";
      hash = "sha256-AkEEVvei9j3PrgAbPmcUrZp8H6mmU/icZ4Py1eqmylc=";
    };
  };
  eldritch-nvim = build {
    name = "eldritch.nvim";
    src = fetchFromGitHub {
      owner = "tsssni";
      repo = "eldritch.nvim";
      rev = "e915020";
      hash = "sha256-tJEosBj17nr+mvSDq3QwQrfEycK+uHdfSpBB4k4wGwQ=";
    };
  };
  incline-nvim = build {
    name = "incline";
    src = fetchFromGitHub {
      owner = "b0o";
      repo = "incline.nvim";
      rev = "16fc9c0";
      hash = "sha256-5DoIvIdAZV7ZgmQO2XmbM3G+nNn4tAumsShoN3rDGrs=";
    };
  };
}
