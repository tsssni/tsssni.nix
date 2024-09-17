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
	};

	outputs = {
    nixpkgs
    , nix-darwin
    , home-manager
    , nixvim
    , ags
    , self
  }@inputs: 
  let
    lib = inputs.nixpkgs.lib;
    configArgs = {
      inherit inputs;
      tsssni = { inherit (self) pkgs lib nixosModules darwinModules homeManagerModules; };
    };
    collectRoot = root: args: lib.mapAttrs (dir: type: 
      if type == "regular" then null
      else import ./configs/${root}/${dir} (args // { host = dir; })
    ) (builtins.readDir ./configs/${root});
    addPrefixToConfigs = configs: builtins.listToAttrs (
        map (host: { 
          name = "tsssni-" + host; 
          value = configs.${host}; }
        ) (builtins.attrNames configs));
    collectConfigs = root: addPrefixToConfigs (collectRoot root configArgs);
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
