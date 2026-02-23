{
  rime-ice,
  rime-moegirl,
  rime-zhwiki,
  buildEnv,
  librime,
  rime-data,
}:
buildEnv {
  name = "rime-tsssni";
  paths = [
    rime-ice
    rime-zhwiki
    rime-moegirl
  ];
  nativeBuildInputs = [
    librime
  ];
  postBuild = ''
    ln -s ${./rime_ice.custom.yaml} $out/share/rime-data/rime_ice.custom.yaml
    ln -s ${./default.custom.yaml} $out/share/rime-data/default.custom.yaml
    ln -s ${./squirrel.custom.yaml} $out/share/rime-data/squirrel.custom.yaml

    cd $out/share/rime-data/
    for s in *.schema.yaml; do
      rime_deployer --compile "$s" . "${rime-data}/share/rime-data/" ./build
    done

    rm ./build/*.txt
  '';
}
