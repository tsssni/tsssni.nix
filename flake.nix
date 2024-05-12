{
	description = "tsssni flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		hyprland.url = "github:hyprwm/Hyprland";
    ags.url = "github:Aylur/ags";
	};

	outputs = { self, nixpkgs, home-manager, ... }@inputs: {
		nixosConfigurations.tsssni = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
      specialArgs = { inherit inputs; };
			modules = [
				./nixos
				home-manager.nixosModules.home-manager {
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
						users.tsssni = import ./home;
					};
				}
			];
		};
	};
}
