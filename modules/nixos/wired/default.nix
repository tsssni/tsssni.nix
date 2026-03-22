{ lib, ... }:
let
  lib' = import ../../../lib { inherit lib; };
in
{
  imports = lib'.importDir ./.;
}
