{
  pkgs
, ...
}:
let
	build = pkgs.vimUtils.buildVimPlugin;
in 
with pkgs; {
	cyyber-nvim = build {
		name = "cyyber.nvim";
		src = fetchFromGitHub {
			owner = "tsssni";
			repo = "cyyber.nvim";
			rev = "2e3a220";
			hash = "sha256-icgsISur8zORLNckg5FWzr4WNbasg1M7Mcxra3bU4Vg=";
		};
	};
	eldritch-nvim = build {
		name = "eldritch.nvim";
		src = fetchFromGitHub {
			owner = "tsssni";
			repo = "eldritch.nvim";
			rev = "58c09bb";
			hash = "sha256-3pRihyBK+AZD9vLcqMezaeIv47sl9Oxh/+3ZuDv3bv4=";
		};
	};
	sonokai = build {
		name = "sonokai";
		src = fetchFromGitHub {
			owner = "tsssni";
			repo = "sonokai";
			rev = "07ce670";
			hash = "sha256-AXpnp30x2T62rIKbosBuyu8j2lwWfCYhE20S6GF72dI=";
		};
	};
	incline-nvim = build {
		name = "incline";
		src = fetchFromGitHub {
			owner = "tsssni";
			repo = "incline.nvim";
			rev = "6cdd1f0";
			hash = "sha256-LpQ/wE2Xg/Dl3tZuDIKTVyhKd8hxoV6dp+rpz7Pyvo0=";
		};
	};
}
