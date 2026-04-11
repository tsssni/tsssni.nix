args: folder:
{
  lib,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users =
      ./${folder}
      |> builtins.readDir
      |> lib.filterAttrs (dir: type: true && type == "directory" && dir != "system")
      |> lib.mapAttrs (
        dir: _: {
          imports = [ ./${folder}/${dir} ] ++ args.modules.home;
        }
      );
  };
}
