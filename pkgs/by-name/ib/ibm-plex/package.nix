{
  lib,
  stdenvNoCC,
  fetchzip,
  symlinkJoin,
  installFonts,
  families ? [ ],
}:
let
  availableFamilies = import ./hashes.nix;
  availableFamilyNames = builtins.attrNames availableFamilies;
  selectedFamilies = if (families == [ ]) then availableFamilyNames else families;
  unknownFamilies = lib.subtractLists availableFamilyNames families;
  versions = map (f: availableFamilies.${f}.version) availableFamilyNames;
  version = lib.head (lib.sort (a: b: builtins.compareVersions a b > 0) versions);
in
assert lib.assertMsg (unknownFamilies == [ ]) "Unknown font(s): ${toString unknownFamilies}";
stdenvNoCC.mkDerivation {
  pname = "ibm-plex";
  inherit version;

  src = symlinkJoin {
    name = "ibm-plex-src";
    paths = map (
      family:
      fetchzip {
        url = "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-${family}%40${
          availableFamilies.${family}.version
        }/ibm-plex-${family}.zip";
        hash = availableFamilies.${family}.hash;
      }
    ) selectedFamilies;
    postBuild = ''
      find "$out" -name unhinted -exec rm -fr {} +
    '';
  };

  nativeBuildInputs = [ installFonts ];
  sourceRoot = ".";
  outputs = [
    "out"
    "webfont"
  ];

  postInstall = ''
    mkdir -p $webfont/share/fonts/css
    cp $src/css/*.css $webfont/share/fonts/css/
    sed -i \
      -e 's|\.\./fonts/complete/|../|g' \
      -e 's|\.\./fonts/split/|../|g' \
      $webfont/share/fonts/css/*.css
  '';

  meta = {
    description = "IBM Plex Typeface";
    homepage = "https://www.ibm.com/plex/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
