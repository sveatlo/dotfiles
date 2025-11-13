return {
	{
		"mason-org/mason.nvim",
		opts = { ensure_installed = { "taplo" } },
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				taplo = {},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				toml = { "taplo" },
			},
		},
	},
}
