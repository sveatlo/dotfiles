return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				proto = { "buf" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = {
			linters_by_ft = {
				proto = { "buf_lint" },
			},
		},
	},
	{
		"mason-org/mason.nvim",
		optional = true,
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "buf" })
		end,
	},
}
