{ ... }:
{
	programs.git = {
		enable = true;
		userName = "tsssni";
		userEmail = "dingyongyu2002@foxmail.com";
		extraConfig = {
			credential.helper = "store";
			rebase.pull = "rebase";
		};
	};
}
