{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zsh-syntax-highlighting
    zsh-autosuggestions
  ];
  
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 114514;
    sessionVariables = {
      http_proxy = "127.0.0.1:7890";
      https_proxy = "127.0.0.1:7890";
    };
  };
}
