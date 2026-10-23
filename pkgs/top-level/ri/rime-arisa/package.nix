{
  rime-ice,
  rime-moegirl,
  buildEnv,
  runCommand,
  librime,
  boost189,
  rime-data,
}:
let
  librime' = librime.override { boost = boost189; };

  paths = [
    rime-ice
    rime-moegirl
  ];

  dicts = runCommand "rime-arisa-dicts" { nativeBuildInputs = [ librime' ]; } ''
    mkdir data && cd data
    for p in ${toString paths}; do
      cp -rs --no-preserve=mode $p/share/rime-data/. .
    done
    rm -rf build
    printf 'patch:\n  schema_list:\n    - schema: rime_ice\n' > default.custom.yaml
    rime_deployer --build . "${rime-data}/share/rime-data/" $out
  '';

  dev = buildEnv {
    name = "rime-arisa-dev";
    inherit paths;
    nativeBuildInputs = [
      librime'
    ];
    postBuild = ''
      ln -s ${./rime_ice.custom.yaml} $out/share/rime-data/rime_ice.custom.yaml
      ln -s ${./english.schema.yaml} $out/share/rime-data/english.schema.yaml
      ln -s ${./default.custom.yaml} $out/share/rime-data/default.custom.yaml
      ln -s ${./squirrel.custom.yaml} $out/share/rime-data/squirrel.custom.yaml
      cd $out/share/rime-data/

      rm -f ./build
      mkdir ./build
      cp --no-preserve=mode ${dicts}/*.bin ./build/
      rime_deployer --build . "${rime-data}/share/rime-data/" ./build
      rm -f user.yaml
    '';
  };
in
runCommand "rime-arisa" { passthru.librime = librime'; } ''
  mkdir -p $out/share
  cp -rL ${dev}/share/rime-data $out/share/
  cd $out/share/rime-data
  chmod -R u+w .
  rm -r cn_dicts en_dicts *.dict.yaml build/stroke.*
''
