{
  inputs,
  tsssni,
  distro,
  func,
  system,
  eval,
}:
let
  lib = inputs.nixpkgs.lib;
  path = "${distro}/${func}";

  specialArgs = {
    tsssni = {
      inherit
        func
        distro
        system
        ;
      lib = tsssni.lib;
    };
    inherit inputs;
  };

  homeModules =
    path:
    [
      ./${path}
      tsssni.homeModules.tsssni
    ]
    ++ tsssni.extraHomeModules;

  systemModules =
    path:
    [
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
  if (distro != "home-manager") then
    {
      inherit system specialArgs;
      modules = systemModules "${path}";
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
