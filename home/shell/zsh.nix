{ pkgs, ... }:
let
  from = ["zsh-syntax-highlighting-placeholder" "zsh-autosuggestions-placeholder"];
  to = ["${pkgs.zsh-syntax-highlighting}" "${pkgs.zsh-autosuggestions}"];
  zshrc = builtins.replaceStrings from to (builtins.readFile ./config/zsh/zshrc);
in
{
  home.packages = with pkgs; [
    zsh-syntax-highlighting
    zsh-autosuggestions
  ];
  
  home.file.".zshrc".source = ./config/zsh/.zshrc;
  home.file.".config/zsh/zshrc".text = zshrc;
}
