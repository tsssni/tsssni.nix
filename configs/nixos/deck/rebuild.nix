{
  inputs
, tsssni
, func
}:
import ../rebuild.nix {
	inherit inputs tsssni func;
	system = "x86_64-linux";
	extraSystemModules = with inputs; [
		agenix.nixosModules.age
		disko.nixosModules.disko
		jovian.nixosModules.jovian
	];
	extraHomeManagerModules = with inputs; [
		nixvim.homeManagerModules.nixvim
	];
}
