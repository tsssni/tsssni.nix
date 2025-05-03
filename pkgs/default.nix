final: prev: {
	tsssni = {
		plana-grub = final.callPackage ./visual/plana-grub.nix {};
		slang = final.callPackage ./render/slang.nix {};
		vimPlugins = final.callPackage ./nixvim {};
	};
}
