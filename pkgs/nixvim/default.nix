{
  pkgs,
  lib,
  ...
}:
let
  build = pkgs.vimUtils.buildVimPlugin;
  plugins = pkgs.vimPlugins;
in
./.
|> builtins.readDir
|> lib.filterAttrs (dir: type: type == "directory")
|> lib.mapAttrs (dir: _: import ./${dir} build plugins)
