{
  lib,
  stdenv,
  linux,
  linuxManualConfig,
  virtualized ? false,
  dotconfig ? null,
  kernelPatches ? [ ],
  features ? null,
  randstructSeed ? "",
}:
let
  base = linux.override {
    ignoreConfigErrors = true;
    structuredExtraConfig = lib.optionalAttrs (!virtualized) (
      with lib.kernel;
      lib.genAttrs [
        "HYPERV"
        "HYPERVISOR_GUEST"
        "INTEL_TDX_GUEST"
        "KVM_GUEST"
        "MOUSE_PS2_VMMOUSE"
        "PARAVIRT_TIME_ACCOUNTING"
      ] (_: lib.mkForce (option no))
    );
  };

  localmodconfig =
    modules:
    stdenv.mkDerivation {
      pname = "linux-lean-config";
      inherit (base) version src;
      inherit (base.configfile) nativeBuildInputs RUST_LIB_SRC;
      buildPhase = ''
        cp ${base.configfile} .config
        (yes "" || true) | make LSMOD=${modules} localmodconfig
        make olddefconfig
      '';
      installPhase = "cp .config $out";
    };

  kernel =
    if dotconfig == null then
      base
    else
      linuxManualConfig {
        inherit (base) src version modDirVersion;
        inherit randstructSeed;
        kernelPatches = base.kernelPatches ++ kernelPatches;
        configfile = dotconfig;
      };
in
kernel.overrideAttrs (prev: {
  meta = prev.meta // {
    hydraPlatforms = [ ];
  };
  passthru = prev.passthru // {
    features = lib.recursiveUpdate base.features (if features == null then { } else features);
    inherit localmodconfig;
  };
})
