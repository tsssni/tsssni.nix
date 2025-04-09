{
  pkgs
, ...
}:
{
	programs.zsh = {
		enable = true;
		oh-my-zsh = {
			enable = true;
			theme = "";
		};
		syntaxHighlighting.enable = true;
        historySubstringSearch.enable = true;
        autosuggestion.enable = true;
		history = {
			size = 114514;
			save = 114514;
			ignoreAllDups = true;
			saveNoDups = true;
		};
		shellAliases = {
			fastfetch = "DYLD_LIBRARY_PATH=${pkgs.darwin.moltenvk}/lib fastfetch";
		};
		sessionVariables = {
			EDITOR = "nvim";
		};
	};
}
