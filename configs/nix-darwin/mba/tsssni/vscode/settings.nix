{ ... }:
{
  programs.vscode = {
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    userSettings = {
      "files.autoSave" = "afterDelay";
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;
      "terminal.integrated.enableMultiLinePasteWarning" = "never";
      "workbench.colorTheme" = "Eldritch";
      "editor.fontFamily" = "'Liga SFMono Nerd Font'";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.cursorBlinking" = "smooth";
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
      "vscode-neovim.neovimClean" = true;
    };
  };
}
