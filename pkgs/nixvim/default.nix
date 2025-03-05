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
		dependencies = [ pkgs.vimPlugins.lush-nvim ];
	};
	eldritch-nvim = build {
		name = "eldritch.nvim";
		src = fetchFromGitHub {
			owner = "tsssni";
			repo = "eldritch.nvim";
			rev = "2e44fc2";
			hash = "sha256-cCyH/0lXkfvS0Cob5npiI2HCC902p7aYXi06jvOLY34=";
		};
	};
	sonokai = build {
		name = "sonokai";
		src = fetchFromGitHub {
			owner = "tsssni";
			repo = "sonokai";
			rev = "4d459c1";
			hash = "sha256-Ic3QLJQ2n5PAFEe0BioGqYga1PW6S0W0OCGZ5eM0GjE=";
		};
	};
	incline-nvim = build {
		name = "incline";
		src = fetchFromGitHub {
			owner = "tsssni";
			repo = "incline.nvim";
			rev = "87e6b4d";
			hash = "sha256-Cqq7l7wJXLZl42EnDWoVz3Mc9NHY1B35gg/7XtrDdCo=";
		};
	};
}
