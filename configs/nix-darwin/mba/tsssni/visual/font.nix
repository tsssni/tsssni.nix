{ 
  tsssni
, ...
}:
{
	home.packages = with tsssni.pkgs; [ 
		darwin.nerd-fonts.sf-mono-liga
	];
}
