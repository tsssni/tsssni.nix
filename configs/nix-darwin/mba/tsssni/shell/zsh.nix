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
			fastfetch = "DYLD_LIBRARY_PATH=${pkgs.darwin.moltenvk}/lib fastfetch";
		};
		initExtra = ''
			export EDITOR="nvim"
		'';
	};
}
