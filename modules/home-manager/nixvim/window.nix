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
				key = "<Leader>v";
				action = ":vsp<CR>";
			}
			{
				mode = "n";
				key = "<Leader>s";
				action = ":sp<CR>";
			}
			{
				mode = "n";
				key = "<Leader>h";
				action = "<C-w>h";
			}
			{
				mode = "n";
				key = "<Leader>j";
				action = "<C-w>j";
			}
			{
				mode = "n";
				key = "<Leader>k";
				action = "<C-w>k";
			}
			{
				mode = "n";
				key = "<Leader>l";
				action = "<C-w>l";
			}
			{
				mode = "n";
				key = "<Leader>Left";
				action = ":vertical resize +10<CR>";
			}
			{
				mode = "n";
				key = "<Leader>Down";
				action = ":resize +5<CR>";
			}
			{
				mode = "n";
				key = "<Leader>Up";
				action = ":resize -5<CR>";
			}
			{
				mode ="n";
				key = "<Leader>Right";
				action = ":vertical resize -10<CR>";
			}
		];
	};
}
