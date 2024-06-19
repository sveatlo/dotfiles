return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "Oil" },
	keys = {
		{ "<leader>fo", "<cmd>Oil<cr>", desc = "Open parent directory in oil.nvim" },
	},
	opts = {},
}
