{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  llvmPackages,
  runtimeShell,
  versionCheckHook,
}:

let
  version = "1.0.0";

  targets = {
    x86_64-linux = "x86_64-unknown-linux-gnu";
    aarch64-linux = "aarch64-unknown-linux-gnu";
    aarch64-darwin = "aarch64-apple-darwin";
  };

  hashes = import ./hashes.nix;

  system = stdenv.hostPlatform.system;
  target = targets.${system};
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "clice";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/clice-io/clice/releases/download/v${version}/clice-${version}.${target}.tar.gz";
    hash = hashes.${system};
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin lib $out/

    runHook postInstall
  '';

  postFixup = ''
    mv $out/bin/clice $out/bin/.clice-wrapped
    substitute ${./wrapper} $out/bin/clice \
      --replace-fail '@clang@' '${llvmPackages.clang}' \
      --replace-fail '@shell@' '${runtimeShell}' \
      --replace-fail '@out@' "$out"
    chmod --reference=$out/bin/.clice-wrapped $out/bin/clice
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/clice";

  meta = {
    description = "C/C++ language server built on LLVM/Clang";
    longDescription = ''
      clice is a C/C++ language server designed to go beyond clangd and ccls.
      It features multi-process compilation, C++20 named module support,
      compilation contexts, and built-in command-line tools for indexing,
      linting, formatting, querying, and refactoring.
    '';
    homepage = "https://github.com/clice-io/clice";
    changelog = "https://github.com/clice-io/clice/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "clice";
    platforms = builtins.attrNames targets;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
