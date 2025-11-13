return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				sql = { "sqlfmt" },
			},
		},
	},
	{
		"mason-org/mason.nvim",
		optional = true,
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "sqlfmt" })
		end,
	},
}
