{
  lib
, config
, ...
}:
let
	cfg = config.tsssni.nixvim;
in {
	programs.nixvim = lib.mkIf cfg.enable {
		globals = {
			mapleader = " ";
			localmapleader = " ";
		};

		keymaps = [
			{
				mode = "n";
				key = "<C-w>v";
				action = ":vsp<CR>";
			}
			{
				mode = "n";
				key = "<C-w>s";
				action = ":sp<CR>";
			}
			{
				mode = "n";
				key = "<C-w>H";
				action = ":vertical resize +10<CR>";
			}
			{
				mode = "n";
				key = "<C-w>J";
				action = ":resize +5<CR>";
			}
			{
				mode = "n";
				key = "<C-w>K";
				action = ":resize -5<CR>";
			}
			{
				mode ="n";
				key = "<C-w>L";
				action = ":vertical resize -10<CR>";
			}
		];
	};
}
