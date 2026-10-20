{
  icu,
  buildPackages,
}:
icu.overrideAttrs (prev: {
  nativeBuildInputs = prev.nativeBuildInputs ++ [ buildPackages.icu.dev ];
  preConfigure = prev.preConfigure + ''
    pushd data/in
    icupkg -l icudt*l.dat | awk -f ${./filter.awk} > remove.txt
    icupkg -r remove.txt icudt*l.dat
    popd
  '';
})
