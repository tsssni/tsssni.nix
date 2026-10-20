{
  lib,
  pkgs,
  pkgsi686Linux,
  steam,
  buildFHSEnv,
  newScope,
  replaceDependencies,
  glibcLocales,
  glibc-reaper,
  xdg-utils-perless,
  locales ? glibcLocales.override { allLocales = false; },
}:
let
  buildFHSEnv' = buildFHSEnv.override {
    callPackage = newScope {
      pkgs = pkgs // {
        glibcLocales = locales;
      };
    };
  };

  # for reaper
  multiPkgs =
    default: pkgs:
    if pkgs.stdenv.hostPlatform.is32bit then
      with pkgs;
      [
        glibc
        libGL
      ]
    else
      lib.remove pkgs.networkmanager (default pkgs);

  targetPkgs =
    default: pkgs:
    lib.subtractLists [
      pkgs.zenity
      pkgs.xdg-utils
    ] (default pkgs)
    ++ [ xdg-utils-perless ];

  drv = steam.override {
    buildFHSEnv =
      args:
      buildFHSEnv' (
        args
        // {
          multiPkgs = multiPkgs args.multiPkgs;
          targetPkgs = targetPkgs args.targetPkgs;
        }
      );
  };
in
lib.lazyDerivation {
  derivation = replaceDependencies {
    inherit drv;
    replacements = [
      {
        oldDependency = pkgsi686Linux.glibc;
        newDependency = glibc-reaper;
      }
    ];
  };
  meta = steam.meta // {
    hydraPlatforms = [ ];
  };
  passthru = { inherit (drv) run; };
}
