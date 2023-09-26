local M = {
	"numToStr/Navigator.nvim",
	keys = {
		{ "<C-h>", "<cmd>lua require('Navigator').left()<CR>", noremap = true, silent = true },
		{ "<C-k>", "<cmd>lua require('Navigator').up()<CR>", noremap = true, silent = true },
		{ "<C-l>", "<cmd>lua require('Navigator').right()<CR>", noremap = true, silent = true },
		{ "<C-j>", "<cmd>lua require('Navigator').down()<CR>", noremap = true, silent = true },
	},
	config = function()
		require("Navigator").setup()
	end,
}

return M
