{ ... }:
{
  programs.ssh.enable = true;

  home.file.".ssh/config".source = ./config/ssh/config;
}
