{
  lib,
  stdenv,
  store-prune,
}:
drv: paths: libs:
let
  darwin = ''
    keep=" ${lib.concatMapStrings (l: "Qt${l} ") libs}"
    queue="$(find lib/qt-6 -name '*.dylib')"
    for name in $keep; do
      queue="$queue lib/$name.framework/Versions/A/$name"
    done
    while [ -n "$queue" ]; do
      next=""
      for f in $queue; do
        for dep in $(otool -L "$f" | tail -n +2 | awk '{ print $1 }'); do
          case "$dep" in
            "$out"/lib/*.framework/*)
              name=''${dep#"$out/lib/"}
              name=''${name%%.framework/*}
              if [[ "$keep" != *" $name "* ]]; then
                keep="$keep$name "
                next="$next $dep"
              fi
              ;;
          esac
        done
      done
      queue="$next"
    done
    for f in lib/*.framework; do
      name=''${f#lib/}
      name=''${name%.framework}
      [[ "$keep" == *" $name "* ]] || rm -rf "$f"
    done
  '';

  linux = ''
    keep=" ${lib.concatMapStrings (l: "libQt6${l}.so.6 ") libs}"
    queue="$(find lib/qt-6 -name '*.so') $(for l in $keep; do echo lib/$l; done)"
    while [ -n "$queue" ]; do
      next=""
      for f in $queue; do
        for n in $(patchelf --print-needed "$f"); do
          if [ -e "lib/$n" ] && [[ "$keep" != *" $n "* ]]; then
            keep="$keep$n "
            next="$next lib/$n"
          fi
        done
      done
      queue="$next"
    done
    for f in lib/libQt6*.so.*.*.*; do
      base=''${f%%.so.*}
      [[ "$keep" == *" ''${base#lib/}.so.6 "* ]] || rm $base.so*
    done
  '';
in
store-prune drv {
  paths = [
    "bin"
    "libexec"
    "include"
    "metatypes"
    "mkspecs"
    "modules"
    "lib/*.{a,la,prl}"
    "lib/{cmake,pkgconfig,objects-Release}"
    "share/{doc,man}"
  ]
  ++ paths;
  post = if stdenv.hostPlatform.isDarwin then darwin else linux;
}
