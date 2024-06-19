return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jay-babu/mason-null-ls.nvim",
			"folke/todo-comments.nvim",
		},
		opts = {
			servers = {
				dockerls = {},
			},
			setup = {},
			format = {
				timeout_ms = 3000,
			},
		},
		config = function(plugin, opts)
			require("plugins.lsp.servers").setup(plugin, opts)
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "VeryLazy",
		keys = { { "<leader>co", "<cmd>Lspsaga outline<cr>", desc = "Code Outline (overview)" } },
		opts = {
			symbol_in_winbar = {
				enable = false,
			},
			outline = {
				win_width = 50,
				close_after_jump = true,
				keys = {
					jump = "<cr>",
				},
			},
			lightbulb = {
				enable = true,
				virtual_text = false,
			},
		},
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = "Mason",
		keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				"shfmt",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufReadPre",
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			return {
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
				sources = {
					-- other sources defined in pde files - others are here

					-- ╭─────────────╮
					-- │ Diagnostics │
					-- ╰─────────────╯
					nls.builtins.diagnostics.buf,

					-- ╭────────────╮
					-- │ Formatting │
					-- ╰────────────╯
					nls.builtins.formatting.shfmt,
					nls.builtins.formatting.buf,
					-- nls.builtins.formatting.latexindent.with({
					-- 	extra_args = { "-g", "/dev/null" }, -- https://github.com/cmhughes/latexindent.pl/releases/tag/V3.9.3
					-- }),

					--  ╭──────────────╮
					--  │ Code actions │
					--  ╰──────────────╯
					nls.builtins.code_actions.refactoring,
					nls.builtins.code_actions.gitsigns,

					-- ╭───────╮
					-- │ Hover │
					-- ╰───────╯
					nls.builtins.hover.dictionary,
				},
			}
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		opts = { ensure_installed = nil, automatic_installation = true, automatic_setup = false },
	},
	{
		"Bekaboo/dropbar.nvim",
		event = "VeryLazy",
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = { "Trouble" },
		keys = {
			{
				"<leader>cdx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>cdX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cdq",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
			{
				"<leader>ct",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "TODOs list toggle (Trouble)",
			},
		},
	},
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		opts = {},
	},
}
