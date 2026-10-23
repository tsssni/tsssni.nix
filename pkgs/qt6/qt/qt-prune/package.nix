{
  lib,
  store-prune,
}:
drv: paths: libs:
store-prune drv {
  inherit paths;
  post = ''
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
}
