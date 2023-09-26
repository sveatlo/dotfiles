return {
	"simrat39/rust-tools.nvim",
	ft = "rust",
	config = function()
		local lldb_extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
		local codelldb_path = lldb_extension_path .. "adapter/codelldb"
		local liblldb_path = lldb_extension_path .. "lldb/lib/liblldb.so"
		local rust_analyzer_settings = require("core.plugins.lsp.languages.rust")

		require("rust-tools").setup({
			tools = { -- rust-tools options

				-- how to execute terminal commands
				-- options right now: termopen / quickfix
				executor = require("rust-tools.executors").termopen,

				-- callback to execute once rust-analyzer is done initializing the workspace
				-- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
				on_initialized = nil,

				-- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
				reload_workspace_from_cargo_toml = true,

				-- inlay hints are handled by lsp-inlayhints.nvim
				inlay_hints = {
					auto = true,
				},

				-- options same as lsp hover / vim.lsp.util.open_floating_preview()
				hover_actions = {
					-- the border that is used for the hover window
					-- see vim.api.nvim_open_win()
					border = {
						{ "🭽", "FloatBorder" },
						{ "▔", "FloatBorder" },
						{ "🭾", "FloatBorder" },
						{ "▕", "FloatBorder" },
						{ "🭿", "FloatBorder" },
						{ "▁", "FloatBorder" },
						{ "🭼", "FloatBorder" },
						{ "▏", "FloatBorder" },
					},

					-- Maximal width of the hover window. Nil means no max.
					max_width = nil,

					-- Maximal height of the hover window. Nil means no max.
					max_height = nil,

					-- whether the hover action window gets automatically focused
					-- default: false
					auto_focus = false,
				},
			},

			-- all the opts to send to nvim-lspconfig
			-- these override the defaults set by rust-tools.nvim
			-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
			server = {
				-- standalone file support
				-- setting it to false may improve startup time
				standalone = true,
				on_attach = function(client, bufnr)
					require("core.plugins.lsp.utils").custom_lsp_attach(client, bufnr)

					local wk = require("which-key")
					local default_options = { buffer = bufnr, silent = true }
					wk.register({
						c = {
							name = "Coding",
							a = { "<cmd>lua require('rust-tools').hover_actions.hover_actions()<CR>", "Hover actions" },
							r = { "<cmd>lua require('rust-tools').runnables.runnables()<cr>", "Runnables" },
							d = { "<cmd>lua require('rust-tools').debuggables.debuggables()<cr>", "Debuggables" },
							e = { "<cmd>lua require('rust-tools').expand_macro.expand_macro()<cr>", "Expand macro" },
						},
					}, { prefix = "<leader>", mode = "n", default_options })
				end,
				settings = {
					["rust-analyzer"] = rust_analyzer_settings,
				},
			}, -- rust-analyzer options

			-- debugging stuff
			dap = {
				adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
				-- adapter = {
				-- 	type = "executable",
				-- 	command = "lldb-vscode",
				-- 	name = "rt_lldb",
				-- },
			},
		})
	end,
}
