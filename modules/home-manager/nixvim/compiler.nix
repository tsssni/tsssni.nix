{
  pkgs
, lib
, config
, tsssni
, ...
}:
let
	cfg = config.tsssni.nixvim;
in {
	programs.nixvim = lib.mkIf cfg.enable {
		plugins = {
			treesitter = {
				enable = true;
				nixvimInjections = true;
				grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars;
				nixGrammars = true;
				settings = {
					auto_install = false;
					highlight.enable = true;
					incremental_selection = {
						enable = true;
						keymaps = {
							init_selection = "<C-s>";
							node_incremental = "<C-u>";
							node_decremental = "<C-d>";
						};
					};
					indent.enable = false;
				};
			};
			lsp = {
				enable = true;
				keymaps = {
					diagnostic = {
						gl = "setloclist";
					};
					lspBuf = {
						gD = "declaration";
						gd = "definition";
						gR = "rename";
						gr = "references";
						gf = "format";
						gh = "hover";
					};
				};
				servers = {
					clangd = {
						enable = true;
						cmd = [
							"clangd"
							"--header-insertion=never"
							"--function-arg-placeholders=false"
							"--inlay-hints=false"
						];
					};
					slangd = {
						enable = true;
						package = tsssni.pkgs.slang;
					};
					cmake.enable = true;
					lua_ls.enable = true;
					nixd.enable = true;
					pylyzer.enable = true;
				};
			};
			dap.enable = true;
			blink-cmp = {
				enable = true;
				settings = {
					keymap = {
						"<Enter>" = ["select_and_accept"];
						"<C-u>" = ["scroll_documentation_up"];
						"<C-d>" = ["scroll_documentation_down"];
						"<C-n>" = ["select_next"];
						"<C-p>" = ["select_prev"];
						"<C-space>" = [
							"show"
							"show_documentation"
							"hide_documentation"
						];
					};
					cmdline.enabled = true;
					sources = {
						default = [
							"lsp"
							"buffer"
							"path"
							# "copilot"
						];
						# providers.copilot = {
						# 	async = true;
						# 	module = "blink-copilot";
						# 	name = "copilot";
						# 	score_offset = 100;
						# };
					};
				};
			};
			# blink-copilot.enable = true;
			# copilot-lua = {
			# 	enable = true;
			# 	settings = {
			# 		panel.enabled = false;
			# 		suggestion.enabled = false;
			# 	};
			# };
			nvim-autopairs.enable = true;
		};

		filetype.extension = {
			slang = "shaderslang";
			glsl = "glsl";
			hlsl = "hlsl";
		};

		keymaps = [
			{
				mode = [ "n" ];
				key = "<leader>c";
				action.__raw = "require('dap').continue";
			}
			{
				mode = [ "n" ];
				key = "<leader>ov";
				action.__raw = "require('dap').step_over";
			}
			{
				mode = [ "n" ];
				key = "<leader>i";
				action.__raw = "require('dap').step_into";
			}
			{
				mode = [ "n" ];
				key = "<leader>ot";
				action.__raw = "require('dap').step_out";
			}
			{
				mode = [ "n" ];
				key = "<leader>b";
				action.__raw = "require('dap').toggle_breakpoint";
			}
		];

		extraConfigLua = ''
			vim.fn.sign_define('DapBreakpoint', { text='', texthl='DiagnosticError' })
			vim.fn.sign_define('DiagnosticSignError', { text='', texthl='DiagnosticError' })
			vim.fn.sign_define('DiagnosticSignWarn', { text='', texthl='DiagnosticWarn' })
			vim.fn.sign_define('DiagnosticSignInfo', { text='', texthl='DiagnosticInfo' })
			vim.fn.sign_define('DiagnosticSignHint', { text='', texthl='DiagnosticHint' })
		'';
	};

	home.packages = with pkgs; [
		copilot-language-server
	];
}
