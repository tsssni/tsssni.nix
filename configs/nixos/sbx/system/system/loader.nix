{ 
  config
, ...
}:
{
	boot.loader.grub = {
		enable = !config.boot.isContainer;
		default = "saved";
		devices = [ "/dev/vda" ];
	};
}
