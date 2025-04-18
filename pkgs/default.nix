{ 
  nixpkgs
}:
{
  localSystem
, crossSystem ? localSystem
, config ? {}
}:
let
	pkgs = import nixpkgs {
		inherit
			localSystem
			crossSystem
			config
		;
	};
	lib = nixpkgs.lib;
	fullLocalSystem = lib.systems.elaborate localSystem;
	fullCrossSystem = lib.systems.elaborate crossSystem;
in with pkgs; {
	darwin = callPackage ./darwin {};
	gnu = callPackage ./gnu {};
	plana-grub = callPackage ./visual/plana-grub.nix {};
	slang = callPackage ./render/slang.nix {};
	vimPlugins = callPackage ./nixvim {};
	vscode-extensions = callPackage ./vscode {};
}
