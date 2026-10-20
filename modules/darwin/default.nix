{
  lib,
  ...
}:
{
  imports = lib.importDir ./. ++ [ ../system ];
}
