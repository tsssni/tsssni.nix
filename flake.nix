{
	description = "tsssni flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    , home-manager
    , nixvim
    , ags
    , self
  }@inputs: 
  let
    lib = inputs.nixpkgs.lib;
    collectConfigs = args: root: lib.mapAttrs (dir: type: 
      if type == "regular" then null
      else import ./configs/${root}/${dir} (args // { host = dir; })
    ) (builtins.readDir ./configs/${root});
    addPrefixToConfigs = configs: builtins.listToAttrs (
        map (host: { 
          name = "tsssni-" + host; 
          value = configs.${host}; }
        ) (builtins.attrNames configs));
  in rec {
    pkgs = import ./pkgs { inherit (inputs) nixpkgs; };
    lib = import ./lib { inherit (inputs.nixpkgs) lib; };
    nixosModules = {
      tsssni = import ./modules/nixos self;
      default = self.nixosModules.tsssni;
    };
    homeManagerModules = {
      tsssni = import ./modules/home-manager self;
      default = self.homeManagerModules.tsssni;
    };
    nixosConfigurations = let
      args = { inherit inputs; tsssni = { inherit pkgs lib nixosModules homeManagerModules; }; };
    in (addPrefixToConfigs (collectConfigs args "nixos"));
	};
}
