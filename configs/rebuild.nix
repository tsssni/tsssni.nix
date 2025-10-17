{
  inputs,
  tsssni,
  distro,
  func,
  system,
  eval,
  cudaSupport ? false,
  rocmSupport ? false,
}:
let
  lib = inputs.nixpkgs.lib;
  path = "${distro}/${func}";
  rebuildModules = [
    {
      tsssni.nix.enable = true;
    }
    {
      nixpkgs = {
        inherit system;
        config =
          { }
          // {
            allowUnfree = true;
          }
          // lib.optionalAttrs (distro == "nixos") {
            inherit cudaSupport rocmSupport;
          };
        overlays =
          with inputs;
          (
            [
              (final: prev: {
                agenix = agenix.packages.${system}.default;
              })
            ]
            ++ (import ../pkgs lib)
          );
      };
    }
  ];

  specialArgs = {
    tsssni = {
      inherit
        inputs
        distro
        func
        system
        ;
    }
    // tsssni;
  };

  homeModules =
    path:
    [
      ./${path}
      tsssni.homeModules.tsssni
    ]
    ++ lib.optionals (distro == "home-manager") rebuildModules
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
    ++ rebuildModules
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
