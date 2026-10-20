{
  scx,
}:
scx
// {
  rustscheds = scx.rustscheds.overrideAttrs (prev: {
    cargoBuildFlags = [
      "-p"
      "scx_lavd"
    ];
    postInstall = "";
    doInstallCheck = false;
    passthru = prev.passthru // {
      schedulers = [ "scx_lavd" ];
    };
  });
}
