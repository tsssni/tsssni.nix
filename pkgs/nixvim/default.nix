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
      rev = "08b1b4f";
      hash = "sha256-z7/QHtcdYmfGoI436UVDy53AsJZppck788jF6gD48ho=";
    };
  };
  eldritch-nvim = build {
    name = "eldritch.nvim";
    src = fetchFromGitHub {
      owner = "eldritch-theme";
      repo = "eldritch.nvim";
      rev = "48788ef";
      hash = "sha256-ShjgOkzE4h5zLsM9kSXePXgZossgwV2HW4Axq5y9cP4=";
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
