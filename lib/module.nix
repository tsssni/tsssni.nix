{
  lib,
}:
{
  importDir =
    dir:
    lib.concatLists (
      lib.mapAttrsToList (
        name: type:
        if type == "directory" && builtins.pathExists (dir + "/${name}/default.nix") then
          [ (dir + "/${name}") ]
        else if type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" then
          [ (dir + "/${name}") ]
        else
          [ ]
      ) (builtins.readDir dir)
    );
}
