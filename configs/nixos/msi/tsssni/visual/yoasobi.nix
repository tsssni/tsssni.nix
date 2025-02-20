{
  pkgs
, ...
}:
{
	home.packages = with pkgs; [
		bluez
		alsa-utils
		go-musicfox
	];
}
