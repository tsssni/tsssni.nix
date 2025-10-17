{
  inputs,
  tsssni,
  distro,
  func,
  eval,
  system,
  cuda ? false,
  rocm ? false,
}:
let
  lib = inputs.nixpkgs.lib;
  path = "${distro}/${func}";
  specialArgs.tsssni = {
    inherit inputs distro func eval system cuda rocm;
  };

  homeModules =
    path:
    [
      ./${path}
      tsssni.homeModules.tsssni
    ]
    ++ lib.optionals (distro == "home") [
      ./prelude
    ]
    ++ tsssni.extraHomeModules;

  systemModules = [
    ./prelude
    ./${path}/system
    tsssni.systemModules
    inputs.home-manager.systemModules
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = specialArgs;
        users =
          ./${path}
          |> builtins.readDir
          |> lib.filterAttrs (dir: type: true && type == "directory" && dir != "system")
          |> lib.mapAttrs (
            dir: _: {
              imports = homeModules "${path}/${dir}";
            }
          );
      };
    }
  ]
  ++ tsssni.extraSystemModules;
in
eval (
  if (distro != "home") then
    {
      inherit system specialArgs;
      modules = systemModules;
    }
  else
    {
      pkgs = import inputs.nixpkgs {
        inherit system;
      };
      extraSpecialArgs = specialArgs;
      modules = homeModules "${path}";
    }
)
