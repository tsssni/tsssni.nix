{ ... }:
{
	programs.git = {
		enable = true;
		userName = "tsssni";
		userEmail = "dingyongyu2002@foxmail.com";
		lfs.enable = true;
		extraConfig = {
			credential.helper = "store";
			rebase.pull = "rebase";
		};
	};
}
