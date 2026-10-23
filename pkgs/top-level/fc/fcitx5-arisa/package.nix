{
  lib,
  emptyDirectory,
  qt6Packages,
  fcitx5,
  fcitx5-gtk,
  enchant,
  gtk4,
  addons ? [ ],
}:
let
  unused = [
    "clipboard"
    "fcitx4frontend"
    "ibusfrontend"
    "imselector"
    "kimpanel"
    "notificationitem"
    "notifications"
    "quickphrase"
    "spell"
    "unicode"
    "virtualkeyboard"
  ];
  fcitx5' = fcitx5.overrideAttrs (prev: {
    buildInputs = lib.remove enchant prev.buildInputs;
    cmakeFlags = prev.cmakeFlags ++ [
      "-DENABLE_ENCHANT=off"
      "-DENABLE_EMOJI=off"
      "-DBUILD_SPELL_DICT=off"
      "-DENABLE_TESTING_ADDONS=off"
      "-DENABLE_TEST=off"
    ];
    postInstall = (prev.postInstall or "") + ''
      cd $out
      rm -r share/fcitx5/{unicode,data/quickphrase.d}
      ${lib.concatMapStrings (m: "rm lib/fcitx5/lib${m}.so share/fcitx5/addon/${m}.conf\n") unused}
      cd -
    '';
  });
  rebase = p: p.override (args: lib.optionalAttrs (args ? fcitx5) { fcitx5 = fcitx5'; });
in
qt6Packages.fcitx5-with-addons.override {
  fcitx5 = fcitx5';
  addons = map rebase addons;
  libsForQt5.fcitx5-qt = emptyDirectory;
  qt6Packages.fcitx5-qt = emptyDirectory;
  fcitx5-gtk = (rebase fcitx5-gtk).overrideAttrs (prev: {
    buildInputs = lib.remove gtk4 prev.buildInputs;
    cmakeFlags = prev.cmakeFlags ++ [ "-DENABLE_GTK4_IM_MODULE=off" ];
  });
  withConfigtool = false;
}
