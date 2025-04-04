{
  inputs
, tsssni
, distro
, func
, system
, eval
, extraSpecialArgs ? {}
, extraSystemModules ? []
, extraHomeManagerModules ? []
}:
let
	lib = inputs.nixpkgs.lib;
	path = "${distro}/${func}";
	specialArgs = {}
		// {
			tsssni = {
				inherit
					func
					distro
					system;
				pkgs = tsssni.pkgs { 
					localSystem = system;
					config.allowUnfree = true;
				};
				lib = tsssni.lib;
			};
			inherit inputs;
		}
		// extraSpecialArgs;
	homeManagerModules = path: []
	++ [
		./${path}
		tsssni.homeManagerModules.tsssni
	]
	++ extraHomeManagerModules;
in eval
(if (distro != "home-manager") then {
	inherit system;
	specialArgs = specialArgs;
	modules = []
		++ [
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
		]
		++ extraSystemModules;
} else {
	pkgs = import inputs.nixpkgs { inherit system; };
	extraSpecialArgs = specialArgs;
	modules = homeManagerModules "${path}";
})
