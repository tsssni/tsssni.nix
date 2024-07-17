{ pkgs, ... }:
{
  programs.nixvim.extraPlugins = with pkgs; [ vimPlugins.cmake-tools-nvim ];
}
