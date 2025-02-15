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
      rev = "79f9504";
      hash = "sha256-9srEqlOVRT++KmLComDCjPtgt+CrDxculMSLB0MTh6I=";
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
  sonokai = build {
    name = "sonokai";
    src = fetchFromGitHub {
      owner = "tsssni";
      repo = "sonokai";
      rev = "07ce670";
      hash = "sha256-AXpnp30x2T62rIKbosBuyu8j2lwWfCYhE20S6GF72dI=";
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
