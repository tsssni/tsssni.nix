{
  lib,
  stdenv,
  darwin,
  runCommandLocal,
  nix,
  patchelf,
}:
drv:
{
  paths ? [ ],
  post ? "",
}:
runCommandLocal
  (drv.name + lib.optionalString ((drv.outputName or "out") != "out") "-${drv.outputName}")
  {
    nativeBuildInputs = [
      nix
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux patchelf
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.cctools
      darwin.autoSignDarwinBinariesHook
    ];
    meta = removeAttrs (drv.meta or { }) [ "outputsToInstall" ] // {
      platforms = drv.meta.platforms or lib.platforms.all;
    };
  }
  ''
    nix-store --dump ${drv} \
      | sed "s|${builtins.substring 11 32 "${drv}"}|$(basename $out | cut -c1-32)|g" \
      | nix-store --restore $out
    chmod -R u+w $out
    cd $out
    rm -rf ${lib.concatStringsSep " " paths}
    ${post}
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''signDarwinBinariesIn "$out"''}
  ''
