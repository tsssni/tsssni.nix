{
  config,
  ...
}:
{
  tsssni.infra.hydra = {
    kernel = config.boot.kernelPackages.kernel;
    modules = config.system.modulesTree;
    nvidia = config.hardware.nvidia.package;
    nu-completions = config.home-manager.users.tsssni.tsssni.intef.shell.completions;
  };
}
