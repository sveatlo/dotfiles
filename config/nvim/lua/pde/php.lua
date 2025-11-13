return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "php" } },
	},

	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				phpactor = {
					enabled = true,
				},
			},
		},
	},

	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"phpcs",
				"php-cs-fixer",
			},
		},
	},
	{
		"mfussenegger/nvim-dap",
		optional = true,
		opts = function()
			local dap = require("dap")
			local path = require("mason-registry").get_package("php-debug-adapter"):get_install_path()
			dap.adapters.php = {
				type = "executable",
				command = "node",
				args = { path .. "/extension/out/phpDebug.js" },
			}
		end,
	},
	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = {
			linters_by_ft = {
				php = { "phpcs" },
			},
		},
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				php = { "php_cs_fixer" },
			},
		},
	},
}
