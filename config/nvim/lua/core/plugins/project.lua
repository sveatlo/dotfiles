local M = {
	"ahmedkhalf/project.nvim",
	-- can't use 'opts' because module has non standard name 'project_nvim'
	config = function()
		require("project_nvim").setup({
			patterns = {
				"Cargo.toml",
				"go.mod",
				"package.json",
				".terraform",
				"requirements.yml",
				"pyrightconfig.json",
				"pyproject.toml",
				".git",
			},
			-- detection_methods = { "lsp", "pattern" },
			detection_methods = { "pattern" },
			silent_chdir = false,
			exclude_dirs = { "~/.config/nvim" },
		})
	end,
}

return M
