{
  pkgs
, tsssni
, ...
}:
{
	programs.vscode = {
		enable = true;
		profiles.default.extensions = []
			++ (with pkgs.vscode-extensions; [
				# ms-python.python
				ms-vscode.cpptools-extension-pack
				ms-vscode-remote.remote-ssh
				asvetliakov.vscode-neovim
				yzhang.markdown-all-in-one
			])
			++ (with tsssni.pkgs.vscode-extensions; [
				Eldritch.eldritch
			]);
	};
}
