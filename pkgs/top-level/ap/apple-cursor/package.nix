{
  lib,
  apple-cursor,
  python3,
  runCommand,
  sizes ? [
    24
    32
    40
    48
  ],
}:
runCommand "apple-cursor-${apple-cursor.version}"
  {
    nativeBuildInputs = [ python3 ];
    meta = { inherit (apple-cursor.meta) platforms; };
  }
  ''
    mkdir -p $out/share/icons
    cp -a ${apple-cursor}/share/icons/macOS $out/share/icons/
    chmod -R u+w $out
    find $out/share/icons/macOS/cursors -type f -exec \
      python3 ${./resize.py} ${lib.concatMapStringsSep "," toString sizes} {} +
  ''
