{
  lib,
  ...
}:
{
  options.tsssni.infra.hydra = lib.mkOption {
    type = with lib.types; attrsOf package;
    default = { };
  };
}
