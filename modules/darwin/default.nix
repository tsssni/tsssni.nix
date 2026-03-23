{ lib, ... }:
{
  imports = lib.importDir ./services/wired ++ [ ../system ];
}
