{ ... }:
{
	disko = {
		enableConfig = true;
		devices = {
			disk.main = {
				device = "/dev/nvme0n1";
				type = "disk";
				content = {
					type = "gpt";
					partitions = {
						ESP = {
							name = "ESP";
							start = "1M";
							end = "512M";
							type = "EF00";
							priority = 1;
							content = {
								type = "filesystem";
								format = "vfat";
								mountpoint = "/efi";
								mountOptions = [ "umask=0077" ];
							};
						};

						root = {
							size = "100%";
							content = {
								type = "filesystem";
								format = "btrfs";
								mountpoint = "/";
								mountOptions = [ "compress=zstd" ];
							};
						};
					};
				};
			};
		};
	};
}
