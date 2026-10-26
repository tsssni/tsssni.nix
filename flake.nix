{
  description = "tsssni flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems = {
      url = "path:./systems.nix";
      flake = false;
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
    };
    json2steamshortcut = {
      url = "github:ChrisOboe/json2steamshortcut";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs =
    {
      self,
      flake-parts,
      ...
    }@inputs:
    let
      lib = inputs.nixpkgs.lib;

      systemPkgs =
        system:
        import inputs.nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
          config.allowUnfree = true;
        };

      collectOverlays =
        scopes: scopes |> lib.mapAttrsToList (_: scope: scope.merge) |> lib.composeManyExtensions;

      collectPackages =
        scopes: pkgs:
        scopes
        |> lib.concatMapAttrs (_: scope: scope.collect pkgs)
        |> lib.filterAttrs (_: drv: (builtins.tryEval (lib.isDerivation drv)).value)
        |> lib.filterAttrs (_: drv: lib.meta.availableOn pkgs.stdenv.hostPlatform drv);

      collectConfigs =
        folder:
        folder
        |> builtins.readDir
        |> lib.filterAttrs (dir: type: type == "directory")
        |> lib.mapAttrs (dir: _: import (folder + /${dir}/rebuild.nix) inputs // { func = dir; })
        |> lib.mapAttrs (_: args: import (folder + /rebuild.nix) (args // { inherit inputs; }));

      collectHydra =
        packages:
        packages |> lib.mapAttrs (_: lib.filterAttrs (_: p: p.meta.hydraPlatforms or null != [ ]));

      collectJobs =
        configs:
        configs |> lib.mapAttrs (_: c: c.config.tsssni.infra.hydra) |> lib.filterAttrs (_: j: j != { });
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem = { system, pkgs, ... }: {
        _module.args.pkgs = systemPkgs system;
        packages = collectPackages self.scopes pkgs;
      };

      flake = {
        lib = import ./lib lib;
        scopes = import ./pkgs/scopes.nix lib;
        overlays = {
          tsssni = collectOverlays self.scopes;
          default = self.overlays.tsssni;
        };
        nixosModules = {
          tsssni = import ./modules/nixos;
          default = self.nixosModules.tsssni;
        };
        darwinModules = {
          tsssni = import ./modules/darwin;
          default = self.darwinModules.tsssni;
        };
        homeModules = {
          tsssni = import ./modules/home;
          default = self.homeModules.tsssni;
        };
        nixosConfigurations = collectConfigs ./configs/nixos;
        darwinConfigurations = collectConfigs ./configs/darwin;
        homeConfigurations = collectConfigs ./configs/home;
        hydraJobs = {
          packages = collectHydra self.packages;
          nixos = collectJobs self.nixosConfigurations;
          darwin = collectJobs self.darwinConfigurations;
          home = collectJobs self.homeConfigurations;
        };
      };
    };
}
