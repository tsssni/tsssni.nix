{
  zellij,
  zellij-unwrapped,
}:
zellij.override {
  zellij-unwrapped = zellij-unwrapped.overrideAttrs {
    cargoBuildNoDefaultFeatures = true;
    cargoBuildFeatures = [ "plugins_from_target" ];
  };
}
