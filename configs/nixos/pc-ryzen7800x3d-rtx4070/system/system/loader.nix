{
  tsssni
, ...
}:
{
  boot.loader = {
    grub = {
      enable = true;
      zfsSupport = true;
      efiSupport = true;
      useOSProber = true;
      mirroredBoots = [
        {
          devices = [ "nodev" ];
          path = "/efi";
        }
      ];
      theme = tsssni.pkgs.tsssni-grub-theme;
      configurationLimit = 5;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
  };
}
