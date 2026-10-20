{
  lib,
  ...
}:
{
  imports = lib.importDir ./. ++ [
    ../system
    ../universal
  ];
}
