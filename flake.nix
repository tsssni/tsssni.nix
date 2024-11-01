{
  description = "tsssni flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
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
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
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
      tsssni = import ./modules/nixos self;
      default = self.nixosModules.tsssni;
    };
    darwinModules = {
      tsssni = import ./modules/nix-darwin self;
      default = self.darwinModules.tsssni;
    };
    homeManagerModules = {
      tsssni = import ./modules/home-manager self;
      default = self.homeManagerModules.tsssni;
    };
    nixosConfigurations = collectConfigs "nixos";
    darwinConfigurations = collectConfigs "nix-darwin";
  };
}
