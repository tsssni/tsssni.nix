{
  inputs,
  tsssni,
  distro,
  func,
  eval,
  system,
  config ? { },
}:
let
  lib = inputs.nixpkgs.lib;
  folder = "${distro}/${func}";
  pkgs = import inputs.nixpkgs {
    inherit system;
  };
  specialArgs.tsssni = {
    inherit
      inputs
      distro
      func
      eval
      system
      config
      ;
  };

  homeModules =
    folder:
    [
      ./${folder}
      tsssni.homeModules.tsssni
    ]
    ++ lib.optionals (distro == "home") [ ./prelude.nix ]
    ++ tsssni.extraHomeModules;

  systemModules = [
    ./${folder}/system
    ./prelude.nix
    tsssni.systemModules
    inputs.home-manager.systemModules
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = specialArgs;
        users =
          ./${folder}
          |> builtins.readDir
          |> lib.filterAttrs (dir: type: true && type == "directory" && dir != "system")
          |> lib.mapAttrs (
            dir: _: {
              imports = homeModules "${folder}/${dir}";
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
      inherit pkgs;
      extraSpecialArgs = specialArgs;
      modules = homeModules "${folder}";
    }
)
