{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
  libllvm,
}:
stdenv.mkDerivation rec {
  pname = "slang";
  version = "2025.7";

  src = fetchFromGitHub {
    owner = "shader-slang";
    repo = "slang";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-kUltUqmUdjuHYAE2W76f3Ns2hCEMU9Op+7u3+sT9BKg=";
  };

  nativeBuildInputs =
    [ ]
    ++ [
      cmake
      ninja
      python3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libllvm
    ];

  cmakeFlags = [
    "--preset default"
    "-DSLANG_ENABLE_SLANG_RHI=OFF"
    "-DSLANG_ENABLE_PREBUILD_BINARIES=OFF"
    "-DSLANG_ENABLE_GFX=OFF"
    "-DSLANG_ENABLE_SLANGRT=OFF"
    "-DSLANG_ENABLE_SLANG_GLSLANG=OFF"
    "-DSLANG_ENABLE_TESTS=OFF"
    "-DSLANG_ENABLE_EXAMPLES=OFF"
    "-DSLANG_ENABLE_REPLAYER=OFF"
  ];

  buildPhase = ''
    		cd ..
    		cmake --build --preset release
    	'';

  installPhase = ''
    		mkdir -p $out
    		cp -r build/Release/* $out/
    	'';

  meta = {
    description = "Making it easier to work with shaders";
    homepage = "shader-slang.com";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    platforms = with lib.platforms; (linux ++ darwin ++ windows);
  };
}
