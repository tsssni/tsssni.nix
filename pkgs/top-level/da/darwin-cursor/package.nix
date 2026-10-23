{
  apple-cursor,
  runCommand,
}:
runCommand "darwin-cursor-${apple-cursor.version}" { } ''
  mkdir -p $out/share/icons
  cp -a ${apple-cursor}/share/icons/macOS $out/share/icons/
''
