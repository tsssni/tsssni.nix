{
  lib,
  SDL2,
  gamescope,
  ...
}@args:
(gamescope.override (
  removeAttrs args [
    "lib"
    "SDL2"
    "gamescope"
  ]
)).overrideAttrs
  (prev: {
    buildInputs = lib.remove SDL2 prev.buildInputs;
    mesonFlags = prev.mesonFlags ++ [ (lib.mesonEnable "sdl2_backend" false) ];
  })
