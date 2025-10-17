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
  isHome = distro == "home-manager";
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

  rebuildModules = [
    (
      {
        pkgs,
        ...
      }:
      {
        nix = {
          package = pkgs.nix;
          nixPath = [
            "nixpkgs=${inputs.nixpkgs}"
          ];
          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
              "pipe-operators"
            ];
            substituters = [
              "https://cache.nixos.org"
              "https://cache.garnix.io"
            ];
            trusted-substituters = [
              "https://cache.garnix.io"
            ];
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
            ];
          };
        }
        // lib.optionalAttrs (!isHome) {
          gc = {
            automatic = true;
            options = "--delete-older-than 7d";
          }
          // lib.optionalAttrs pkgs.stdenv.isLinux {
            persistent = true;
            dates = "Tue 04:00";
          }
          // lib.optionalAttrs pkgs.stdenv.isDarwin {
            interval = {
              Weekday = 2;
              Hour = 4;
              Minute = 0;
            };
          };
          optimise.automatic = true;
        };
      }
      // lib.optionalAttrs (!isHome) {
        environment.systemPackages = with pkgs; [
          nh
        ];
      }
      // lib.optionalAttrs isHome {
        home.packages = with pkgs; [
          nix
          nh
        ];
      }
    )
    {
      nixpkgs = {
        inherit system;
        config = {
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

  homeModules =
    path:
    [
      ./${path}
      tsssni.homeModules.tsssni
    ]
    ++ lib.optionals isHome rebuildModules
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
  if !isHome then
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
