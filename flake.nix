{
	description = "tsssni flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    tsssni-nur = {
      url = "github:tsssni/nur-packages";
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
    , tsssni-nur
    , home-manager
    , nixvim
    , ags
    , ... 
  }:
  let
    system = "x86_64-linux";
    tsssni-pkgs = tsssni-nur.packages.${system};
  in 
  {
		nixosConfigurations.tsssni = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit tsssni-pkgs; };
			modules = [
				./nixos
				home-manager.nixosModules.home-manager {
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
            extraSpecialArgs = { inherit tsssni-pkgs nixvim ags; };
						users.tsssni = import ./home;
					};
				}
			];
		};
	};
}
