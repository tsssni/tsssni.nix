{
  pkgs
, ...
}:
{
	programs.zsh = {
		enable = true;
		syntaxHighlighting.enable = true;
		historySubstringSearch.enable = true;
		autosuggestion.enable = true;
		history = {
			size = 114514;
			save = 114514;
		};
		shellAliases = {
			fastfetch = "fastfetch --lib-vulkan ${pkgs.darwin.moltenvk}/lib/libMoltenVK.dylib --lib-imagemagick ${pkgs.imagemagick}/lib/libMagickCore-7.Q16HDRI.dylib";
		};
		initExtra = ''
			export EDITOR="nvim"
		'';
	};
}
