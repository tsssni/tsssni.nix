{
  lib,
  stdenv,
  codex,
  gst_all_1,
  removeReferencesTo,
  store-prune,
}:
if stdenv.hostPlatform.isDarwin then
  codex
else
  store-prune codex {
    paths = [
      "bin/logs_client"
      "codex-resources/voice"
    ];
    post = ''
      ${lib.getExe removeReferencesTo} \
        -t ${lib.getLib gst_all_1.gstreamer} \
        -t ${lib.getLib gst_all_1.gst-plugins-base} \
        -t ${lib.getLib gst_all_1.gst-plugins-good} \
        bin/codex
    '';
  }
