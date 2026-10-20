{
  config,
  pkgs,
  ...
}:
{
  tsssni.infra.hydra = {
    kernel = config.boot.kernelPackages.kernel;
    modules = config.system.modulesTree;
    systemd = config.systemd.package;
    mesa = config.hardware.graphics.package;
    radv = pkgs.jovianPackages.mesa-radv;
    scx = pkgs.scx.rustscheds;
    weston = pkgs.weston;
    nu-completions = config.home-manager.users.deck.tsssni.intef.shell.completions;
    jovian = pkgs.linkFarmFromDrvs "jovian" (
      with pkgs.jovianPackages;
      [
        dmemcg-booster
        galileo-mura
        gamescope
        gamescope-session
        inputplumber
        jovian-updater-logo-helper
        mangohud
        pipewire
        powerbuttond
        steam_notif_daemon
        steamdeck-dsp
        steamos-manager
        vpower
        wireplumber
      ]
    );
  };
}
