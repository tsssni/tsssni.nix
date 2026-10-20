{
  apple-cursor,
  emptyDirectory,
  gamescope-session,
  kdePackages,
  runCommand,
}:
(gamescope-session.override {
  ibus = emptyDirectory;
  kdePackages = kdePackages // {
    breeze = runCommand "apple-cursor-steam" { } ''
      mkdir -p $out/share/icons
      ln -s ${apple-cursor}/share/icons/macOS $out/share/icons/steam
    '';
  };
}).overrideAttrs
  (prev: {
    postFixup = (prev.postFixup or "") + ''
      for d in $out/lib/systemd/user $out/share/systemd/user; do
        [ -d $d ] || continue
        rm -f $d/ibus-gamescope.service
        sed -i '/ibus-gamescope/d' $d/gamescope-session.target
      done
    '';
  })
