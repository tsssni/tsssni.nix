{
  lib,
  ...
}:
{
  options.tsssni.infra.hydra = lib.mkOption {
    description = "Hydra build jobs.";
    type = with lib.types; attrsOf package;
    default = { };
  };
}
