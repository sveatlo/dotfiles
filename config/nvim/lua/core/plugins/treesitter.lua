local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "BufReadPost",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"RRethy/nvim-treesitter-endwise",
		"mfussenegger/nvim-ts-hint-textobject",
		"windwp/nvim-ts-autotag",
		"nvim-treesitter/playground",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"cmake",
				"dockerfile",
				"go",
				"hcl",
				"html",
				"javascript",
				"json",
				"latex",
				"ledger",
				"lua",
				"markdown",
				"python",
				"rust",
				"toml",
				"yaml",
			}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
			ignore_install = {}, -- List of parsers to ignore installing
			auto_install = true,
			highlight = {
				enable = true, -- false will disable the whole extension
				disable = {}, -- list of language that will be disabled
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					scope_incremental = "<CR>",
					node_incremental = "<TAB>",
					node_decremental = "<S-TAB>",
				},
			},
			indent = { enable = true },
			autopairs = { { enable = true } },
			textobjects = {
				select = {
					enable = true,
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["ib"] = "@block.inner",
						["ab"] = "@block.outer",
						["ir"] = "@parameter.inner",
						["ar"] = "@parameter.outer",
					},
				},
			},
			rainbow = {
				enable = true,
				extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
				max_file_lines = 2000, -- Do not enable for files with more than specified lines
			},
		})

		require("nvim-ts-autotag").setup()
	end,
}

return M
