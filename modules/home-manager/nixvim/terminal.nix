{
  lib
, config
, ...
}:
let
	cfg = config.tsssni.nixvim;
in {
	programs.nixvim.keymaps = lib.mkIf cfg.enable [
		{
			mode = "n";
			key = "<Leader>t";
			action = ":terminal<CR>";
		}
		{
			mode = "t";
			key = "<C-Esc>";
			action = "<C-\\><C-n>";
		}
	];
}
