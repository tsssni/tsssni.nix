{
  zellij,
  zellij-unwrapped,
}:
zellij.override {
  zellij-unwrapped = zellij-unwrapped.overrideAttrs {
    buildNoDefaultFeatures = true;
    buildFeatures = [ "plugins_from_target" ];
  };
}
