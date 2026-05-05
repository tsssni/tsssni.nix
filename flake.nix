{
  description = "tsssni flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-cherry.url = "github:tsssni/nixpkgs/cherry";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      ...
    }@inputs:
    let
      lib = inputs.nixpkgs.lib;
      args = {
        inherit inputs;
        modules = with inputs; {
          nixos = [
            self.nixosModules.tsssni
            jovian.nixosModules.jovian
            disko.nixosModules.disko
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
          ];
          darwin = [
            self.darwinModules.tsssni
            agenix.darwinModules.age
            home-manager.darwinModules.home-manager
          ];
          home = [
            self.homeModules.tsssni
            nixvim.homeModules.nixvim
          ];
        };
      };
      collectConfigs =
        folder:
        folder
        |> builtins.readDir
        |> lib.filterAttrs (dir: type: type == "directory")
        |> lib.mapAttrs (
          dir: _:
          (import (folder + /rebuild.nix) (
            args // { func = dir; } // (import (folder + /${dir}/rebuild.nix))
          ))
        );
    in
    {
      pkgs = import ./pkgs lib;
      lib = import ./lib lib;
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
    };
}
