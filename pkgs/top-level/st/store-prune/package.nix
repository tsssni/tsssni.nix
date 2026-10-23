{
  lib,
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
      patchelf
    ];
    meta = (drv.meta or { }) // {
      platforms = lib.platforms.linux;
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
  ''
