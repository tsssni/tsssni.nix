{
  lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, python3
}:
stdenv.mkDerivation rec {
	pname = "slang";
	version = "2025.6.1";

	src = fetchFromGitHub {
		owner = "shader-slang";
		repo = "slang";
		tag = "v${version}";
		fetchSubmodules = true;
		hash = "sha256-yNPAJX7OxxQLXDm3s7Hx5QA9fxy1qbAMp4LKYVqxMVM=";
	};

	nativeBuildInputs = [ 
		cmake
		ninja
		python3
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
		cmake --build --preset releaseWithDebugInfo
	'';

	installPhase = ''
		mkdir -p $out
		cp -r build/RelWithDebInfo/* $out/
	'';

	meta = with lib; {
		description = "Making it easier to work with shaders";
		homepage = "shader-slang.com";
		license = licenses.asl20-llvm;
		platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
	};
}
