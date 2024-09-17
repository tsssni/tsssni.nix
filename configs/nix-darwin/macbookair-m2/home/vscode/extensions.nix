{ pkgs, tsssni, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = []
      ++ (with pkgs.vscode-extensions; [
        ms-python.python
        ms-vscode.cpptools-extension-pack
        ms-vscode-remote.remote-ssh
        asvetliakov.vscode-neovim
      ])
      ++ (with tsssni.pkgs.vscode-extensions; [
        Eldritch.eldritch
      ]);
  };
}
