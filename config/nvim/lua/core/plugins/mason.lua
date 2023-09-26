local M = {
	"williamboman/mason.nvim",
	dependencies = {
		{ "williamboman/mason-lspconfig.nvim", module = "mason" },
	},
	config = function()
		-- install_root_dir = path.concat({ vim.fn.stdpath("data"), "mason" }),
		require("mason").setup()

		-- install LSPs
		require("mason-lspconfig").setup({
			ensure_installed = {},
			automatic_installation = true,
		})
	end,
}

return M
