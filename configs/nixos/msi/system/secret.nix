{
  tsssni,
  ...
}:
{
  environment.systemPackages = [
    tsssni.inputs.agenix.packages.${tsssni.system}.default
  ];
}
