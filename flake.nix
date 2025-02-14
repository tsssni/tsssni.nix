{
  description = "tsssni flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
    };
    ags = {
      url = "github:Aylur/ags/v1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix/0.15.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
    };
  };

  outputs = {
    nixpkgs
    , nix-darwin
    , home-manager
    , nixvim
    , ags
    , agenix
    , self
  }@inputs: 
  let
    lib = inputs.nixpkgs.lib;
    configArgs = {
      inherit inputs;
      tsssni = { inherit (self)
        pkgs
        lib
        nixosModules
        darwinModules
        homeManagerModules;
      };
    };
    mapDir = root: dir: type: lib.nameValuePair 
      ("tsssni-" + dir)
      (import ./configs/${root}/${dir} (configArgs // { host = dir; }));
    collectConfigs = root: ./configs/${root}
      |> builtins.readDir
      |> lib.filterAttrs (dir: type: type == "directory")
      |> lib.mapAttrs' (mapDir root);
  in {
    pkgs = import ./pkgs { inherit nixpkgs; };
    lib = import ./lib { inherit lib; };
    nixosModules = {
      tsssni = import ./modules/nixos;
      default = self.nixosModules.tsssni;
    };
    darwinModules = {
      tsssni = import ./modules/nix-darwin;
      default = self.darwinModules.tsssni;
    };
    homeManagerModules = {
      tsssni = import ./modules/home-manager;
      default = self.homeManagerModules.tsssni;
    };
    nixosConfigurations = collectConfigs "nixos";
    darwinConfigurations = collectConfigs "nix-darwin";
  };
}
