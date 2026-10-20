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

  homonym =
    super: name: file:
    lib.optionalAttrs (super ? ${name} && lib.functionArgs (import file) ? ${name}) {
      ${name} = super.${name};
    };

  callByName =
    self: super: name: file:
    self.callPackage file (homonym super name file);
in
self: super: lib.mapAttrs (callByName self super) packageFiles
