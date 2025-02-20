{
  pkgs
, tsssni
, lib
, config
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
							node_incremental = "<C-n>";
							node_decremental = "<C-d>";
						};
					};
					indent.enable = true;
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
					clangd.enable = true;
					slangd = {
						enable = true;
						package = tsssni.pkgs.slang;
					};
					cmake.enable = true;
					lua_ls.enable = true;
					nixd.enable = true;
					pylyzer.enable = true;
					ts_ls.enable = true;
					rust_analyzer = {
						enable = true;
						installRustc = true;
						installCargo = true;
					};
				};
			};
			dap.enable = true;
			cmp = {
				enable = true;
				autoEnableSources = true;
				cmdline = {
					"/" = {
						mapping.__raw = "cmp.mapping.preset.cmdline()";
						sources = [ { name = "buffer"; } ];
					};
					":" = {
						mapping.__raw = "cmp.mapping.preset.cmdline()";
						sources = [
							{ name = "path"; }
							{ name = "cmdline"; }
						];
					};
				};
				settings = {
					snippet.expand.__raw = ''
						function(args)
							require'luasnip'.lsp_expand(args.body)
						end
					'';
					sources = [
							{ name = "nvim_lsp"; }
							{ name = "nvim_lsp_signature_help"; }
							{ name = "nvim_lsp_document_symbol"; }
							{ name = "luasnip"; }
							{ name = "buffer"; }
							{ name = "path"; }
					];
					mapping = {
						"<C-n>".__raw = "cmp.mapping.select_next_item()";
						"<C-p>".__raw = "cmp.mapping.select_prev_item()";
						"<C-d>".__raw = "cmp.mapping.scroll_docs(4)";
						"<C-u>".__raw = "cmp.mapping.scroll_docs(-4)";
						"<C-e>".__raw = "cmp.mapping.abort()";
						"<CR>".__raw = "cmp.mapping.confirm{ select = true }";
					};
				};
			};
			luasnip.enable = true;
			nvim-autopairs.enable = true;
		};

		filetype.extension = {
			slang = "shaderslang";
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
	home = {
		packages = with pkgs; [
			lldb
		];
	};
}
