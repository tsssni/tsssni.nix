{
  inputs
, tsssni
, distro
, func
, system
, eval
}:
let
	lib = inputs.nixpkgs.lib;
	path = "${distro}/${func}";

	specialArgs = {
		tsssni = {
			inherit
				func
				distro
				system;
			lib = tsssni.lib;
		};
		inherit inputs;
	};

	homeManagerModules = path: [
		./${path}
		tsssni.homeManagerModules.tsssni
	] ++ tsssni.extraHomeManagerModules;

	systemModules = path: [
		./${path}/system
		tsssni.systemModules
		inputs.home-manager.systemModules
		{
			home-manager = {
				useGlobalPkgs = true;
				useUserPackages = true;
				extraSpecialArgs = specialArgs;
				users = ./${path}
					|> builtins.readDir
					|> lib.filterAttrs (dir: type: true
						&& type == "directory"
						&& dir != "system"
					)
					|> lib.mapAttrs (dir: _: {
						imports = homeManagerModules "${path}/${dir}";
					});
			};
		}
	] ++ tsssni.extraSystemModules;
in eval
(if (distro != "home-manager") then {
	inherit system;
	specialArgs = specialArgs;
	modules = systemModules "${path}";
} else {
	pkgs = import inputs.nixpkgs {
		inherit system;
		overlays = [
			(import ../pkgs)
		];
	};
	extraSpecialArgs = specialArgs;
	modules = homeManagerModules "${path}";
})
