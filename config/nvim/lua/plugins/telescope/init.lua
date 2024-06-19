return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"jvgrootveld/telescope-zoxide",
			"crispgm/telescope-heading.nvim",
			"nvim-telescope/telescope-symbols.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-dap.nvim",
			"ahmedkhalf/project.nvim",
			"ptethng/telescope-makefile",
			"tsakirist/telescope-lazy.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		keys = {},
		config = function()
			local telescope = require("telescope")
			local telescopeConfig = require("telescope.config")
			local actions = require("telescope.actions")
			local action_layout = require("telescope.actions.layout")

			local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
			table.insert(vimgrep_arguments, "--hidden")
			-- trim the indentation at the beginning of presented line
			table.insert(vimgrep_arguments, "--trim")

			local fzf_opts = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			}

			telescope.setup({
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case" or "smart_case"
					},
					["ui-select"] = {
						layout_config = {
							width = 0.5,
							height = 0.3,
						},
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
					buffers = {
						ignore_current_buffer = true,
						sort_lastused = true,
					},
					-- find_command = { "fd", "--hidden", "--type", "file", "--follow", "--strip-cwd-prefix" },
				},
				defaults = {
					file_ignore_patterns = { "node_modules", ".terraform", "%.jpg", "%.png", ".git" },
					-- used for grep_string and live_grep
					vimgrep_arguments = {
						"rg",
						"--follow",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--no-ignore",
						"--trim",
					},
					mappings = {
						i = {
							-- Close on first esc instead of gonig to normal mode
							-- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
							["<esc>"] = actions.close,
							["<C-j>"] = actions.move_selection_next,
							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_selected_to_qflist,
							["<C-l>"] = actions.send_to_qflist,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<cr>"] = actions.select_default,
							["<c-v>"] = actions.select_vertical,
							["<c-s>"] = actions.select_horizontal,
							["<c-t>"] = actions.select_tab,
							["<c-p>"] = action_layout.toggle_preview,
							["<c-o>"] = action_layout.toggle_mirror,
							["<c-h>"] = actions.which_key,
						},
					},
					prompt_prefix = "> ",
					selection_caret = " ",
					entry_prefix = "  ",
					multi_icon = "<>",
					initial_mode = "insert",
					scroll_strategy = "cycle",
					selection_strategy = "reset",
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",
					layout_config = {
						width = 0.95,
						height = 0.85,
						-- preview_cutoff = 120,
						prompt_position = "top",
						horizontal = {
							preview_width = function(_, cols, _)
								if cols > 200 then
									return math.floor(cols * 0.4)
								else
									return math.floor(cols * 0.6)
								end
							end,
						},
						vertical = { width = 0.9, height = 0.95, preview_height = 0.5 },
						flex = { horizontal = { preview_width = 0.9 } },
					},
					winblend = 0,
					border = {},
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
					use_less = true,
					set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("zoxide")
			telescope.load_extension("heading")
			telescope.load_extension("file_browser")
			telescope.load_extension("dap")
		end,
	},
	{
		"stevearc/aerial.nvim",
		enabled = false,
		config = true,
	},
	{
		"ahmedkhalf/project.nvim",
		event = "VeryLazy",
		-- can't use 'opts' because module has non standard name 'project_nvim'
		config = function()
			require("project_nvim").setup({
				patterns = {
					"lazy-lock.json",
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
				exclude_dirs = {},
			})
		end,
	},
}
