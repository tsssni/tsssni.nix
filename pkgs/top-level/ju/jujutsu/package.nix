{
  jujutsu,
}:
jujutsu.overrideAttrs (prev: {
  cargoBuildFlags = prev.cargoBuildFlags ++ [
    "-p"
    "jj-cli"
  ];
  cargoBuildNoDefaultFeatures = true;
  cargoBuildFeatures = [ "git" ];
})
