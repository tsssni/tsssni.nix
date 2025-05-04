{
  pkgs
, lib
, config
, ...
}:
let
	 cfg = config.tsssni.shell.shell;
in {
	options.tsssni.shell.shell = {
		enable = lib.mkEnableOption "tsssni.shell.shell";
	};

	config = lib.mkIf cfg.enable {
		programs.nushell = {
			enable = true;
			settings = {
				show_banner = false;
			};
			environmentVariables = {
				EDITOR = "nvim";
			} // (lib.optionalAttrs pkgs.stdenv.isLinux {
				XCURSOR_SIZE = 24;
				XCURSOR_THEME = "macOS";
				QT_QPA_PLATFORMTHEME = "qt5ct";

				XDG_SESSION_TYPE = "wayland";
				GBM_BACKEND = "nvidia-drm";
				LIBVA_DRIVER_NAME = "nvidia";
				__GLX_VENDOR_LIBRARY_NAME = "nvidia";
			});
		};
	};
}
