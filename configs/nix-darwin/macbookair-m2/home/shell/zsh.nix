{ pkgs, ... }:
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
    sessionVariables = {
      http_proxy = "127.0.0.1:7890";
      https_proxy = "127.0.0.1:7890";
    };
    shellAliases = {
      fastfetch = "fastfetch --lib-vulkan ${pkgs.darwin.moltenvk}/lib/libMoltenVK.dylib --lib-imagemagick ${pkgs.imagemagick}/lib/libMagickCore-7.Q16HDRI.dylib";
    };
    initExtra = ''
      export EDITOR="nvim"
    '';
  };
}
