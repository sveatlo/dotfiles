return {
	{
		"SmiteshP/nvim-navbuddy",
		dependencies = {
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
			"neovim/nvim-lspconfig",
		},
		keys = {
			{
				"<leader>cO",
				function()
					require("nvim-navbuddy").open()
				end,
				desc = "Code Outline (navigation)",
			},
		},
		opts = { lsp = { auto_attach = true } },
	},
}
