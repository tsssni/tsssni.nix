lib: baseDirectory:
let
  namesForShard =
    shard: type:
    if type != "directory" then
      { }
    else
      lib.mapAttrs (name: _: baseDirectory + "/${shard}/${name}/package.nix") (
        builtins.readDir (baseDirectory + "/${shard}")
      );

  packageFiles = lib.mergeAttrsList (
    lib.mapAttrsToList namesForShard (builtins.readDir baseDirectory)
  );
in
self: _: lib.mapAttrs (_: file: self.callPackage file { }) packageFiles
