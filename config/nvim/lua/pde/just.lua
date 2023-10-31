if not require("config").pde.just then
	return {}
end

return {
	{
		"IndianBoy42/tree-sitter-just",
		config = function()
			require("tree-sitter-just").setup({})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"IndianBoy42/tree-sitter-just",
		},
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "just" })
			end
		end,
	},
}
