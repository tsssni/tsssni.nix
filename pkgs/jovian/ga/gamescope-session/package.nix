{
  emptyDirectory,
  gamescope-session,
  kdePackages,
  lib,
  resholve,
}:
(gamescope-session.override {
  ibus = emptyDirectory;
  resholve = resholve // {
    phraseSolution =
      name: solution:
      resholve.phraseSolution name (
        solution
        // lib.optionalAttrs (name == "gamescope-session") {
          inputs = lib.remove kdePackages.kconfig solution.inputs;
          execer = lib.remove "cannot:${kdePackages.kconfig}/bin/kwriteconfig6" solution.execer;
        }
      );
  };
  kdePackages = kdePackages // {
    breeze = emptyDirectory;
  };
}).overrideAttrs
  (prev: {
    postPatch = (prev.postPatch or "") + ''
      substituteInPlace gamescope-session --replace-fail \
        'kwriteconfig6 --file gtk-3.0/settings.ini  --group Settings --key gtk-cursor-theme-name steam' \
        ':'
    '';
    postFixup = (prev.postFixup or "") + ''
      for d in $out/lib/systemd/user $out/share/systemd/user; do
        [ -d $d ] || continue
        rm -f $d/ibus-gamescope.service
        sed -i '/ibus-gamescope/d' $d/gamescope-session.target
      done
    '';
  })
