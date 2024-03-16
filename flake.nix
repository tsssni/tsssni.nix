{
	description = "tsssni flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		hyprland.url = "github:hyprwm/Hyprland";
	};

	outputs = { nixpkgs, home-manager, hyprland, ... }@inputs: {
		nixosConfigurations.tsssni = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./nixos/system.nix
				hyprland.nixosModules.default
				home-manager.nixosModules.home-manager {
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.tsssni = import ./tsssni/home.nix;
					};
				}
			];
		};
	};
}
