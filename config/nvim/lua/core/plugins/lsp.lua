local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"onsails/lspkind-nvim",
		"nvim-telescope/telescope.nvim",
		{ "folke/neodev.nvim", config = true },
	},
	config = function()
		require("core.plugins.lsp.lsp")
	end,
}

return M
