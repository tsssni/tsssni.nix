{
  inputs
, tsssni
, root
, host
, system
, rebuildFunc
, extraSpecialArgs ? {}
, extraSystemModules ? {}
, extraHomeManagerModules ? {}
}:
let
  specialArgs = {}
    // {
      tsssni = {
        inherit host;
        pkgs = tsssni.pkgs { localSystem = system; };
        lib = tsssni.lib;
      };
    }
    // extraSpecialArgs;
  checkExtraModules = extraModules:
    if inputs.nixpkgs.lib.isList extraModules 
    then extraModules
    else [ extraModules ];
in rebuildFunc {
  inherit system;
  specialArgs = specialArgs;
  modules = []
    ++ [
      ./${root}/${host}/system
      tsssni.systemModule
      inputs.home-manager.systemModule
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
          users.tsssni = { ... }:
          {
            imports = [
              ./${root}/${host}/home
              tsssni.homeManagerModules.tsssni
            ]
            ++ (checkExtraModules extraHomeManagerModules);
          };
        };
      }
    ]
  ++ (checkExtraModules extraSystemModules);
}
