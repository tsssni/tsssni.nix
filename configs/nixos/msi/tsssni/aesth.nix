{ 
 pkgs
, ...
}:
{
	home.packages = with pkgs; [ 
		blender
		gimp
	];
}
