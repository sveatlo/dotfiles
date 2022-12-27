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

local wk = require("which-key")

wk.register({
	p = {
		name = "Project",
		w = { ":SessionManager save_current_session<CR>", "Save session" },
		W = { ":SessionManager delete_session<CR>", "Delete session" },
		["?"] = { ":SessionManager load_session<CR>", "Load session" },
	},
}, { prefix = "<leader>", mode = "n", default_options })
