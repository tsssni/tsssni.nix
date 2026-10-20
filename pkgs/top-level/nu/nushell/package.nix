{
  nushell,
}:
nushell.override {
  withDefaultFeatures = false;
  additionalFeatures = _: [
    "network"
    "rustls-tls"
  ];
}
