{
  config,
  ...
}:
{
  tsssni.infra.hydra = {
    kernel = config.boot.kernelPackages.kernel;
    modules = config.system.modulesTree;
    systemd = config.systemd.package;
  };
}
