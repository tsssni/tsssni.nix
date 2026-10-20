{
  lib,
  systemd,
}:
(systemd.override {
  withApparmor = false;
  withCryptsetup = false;
  withFido2 = false;
  withHomed = false;
  withImds = false;
  withImportd = false;
  withKexectools = false;
  withMachined = false;
  withMountfsd = false;
  withNspawn = false;
  withNsresourced = false;
  withPasswordQuality = false;
  withPortabled = false;
  withRemote = false;
  withRepart = false;
  withResolved = false;
  withSelinux = false;
  withSysinstall = false;
  withSysupdate = false;
  withTpm2Tss = false;
  withVmspawn = false;
}).overrideAttrs
  (prev: {
    mesonFlags = lib.subtractLists [ (lib.mesonEnable "nss-resolve" true) ] prev.mesonFlags ++ [
      (lib.mesonEnable "nss-resolve" false)
    ];
    postInstall = prev.postInstall + ''
      rm $out/lib/udev/hwdb.d/20-{OUI,pci-vendor-model,usb-vendor-model}.hwdb
    '';
  })
