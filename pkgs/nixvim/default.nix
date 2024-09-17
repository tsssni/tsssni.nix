{ pkgs, ... }:
let
  build = pkgs.vimUtils.buildVimPlugin;
in 
with pkgs; {
  tsssni-nvim = build {
    name = "tsssni-theme";
    src = fetchFromGitHub {
      owner = "tsssni";
      repo = "tsssni.nvim";
      rev = "4731cf5";
      hash = "sha256-V9LkOxoh1cJwn4t00c1a0/MkfFUuwIezypkiW46AIPo=";
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
