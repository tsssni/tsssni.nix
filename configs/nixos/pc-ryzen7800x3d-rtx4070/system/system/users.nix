{
  pkgs
, ...
}:
{
  users.users.tsssni = {
    name = "tsssni";
    home = "/home/tsssni";
    shell = pkgs.elvish;
    extraGroups = [ "wheel" ];
    isNormalUser = true;
  };
}
