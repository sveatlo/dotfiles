return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		build = "make",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"ibhagwan/fzf-lua",
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = { insert_mode = true },
						use_absolute_path = true,
					},
				},
			},
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = { file_types = { "markdown", "Avante" } },
				ft = { "markdown", "Avante" },
			},
		},
		opts = {
			provider = "claude",
			providers = {
				claude = {
					endpoint = "https://api.anthropic.com",
					auth_type = "max",
					model = "claude-sonnet-4-6",
					extra_request_body = {
						max_tokens = 8192,
					},
				},
			},
		},
		keys = {
			{ "<leader>aa", "<cmd>AvanteAsk<cr>",     desc = "Ask AI (Avante)",        mode = { "n", "v" } },
			{ "<leader>ae", "<cmd>AvanteEdit<cr>",    desc = "Edit with AI (Avante)",  mode = "v" },
			{ "<leader>at", "<cmd>AvanteToggle<cr>",  desc = "Toggle (Avante)" },
		},
	},

	{
		"folke/edgy.nvim",
		optional = true,
		opts = function(_, opts)
			opts.right = opts.right or {}
			-- Avante sidebar
			table.insert(opts.right, {
				ft = "Avante",
				title = "Avante",
				size = { width = 60 },
			})
			table.insert(opts.right, {
				ft = "AvanteInput",
				title = "Avante Input",
				size = { height = 8 },
			})
			-- Claude Code terminal (snacks, position=right, title="Claude Code")
			table.insert(opts.right, {
				ft = "snacks_terminal",
				title = "Claude Code",
				size = { width = 0.4 },
				filter = function(buf, win)
					return vim.w[win].snacks_win
						and vim.w[win].snacks_win.position == "right"
						and vim.w[win].snacks_win.relative == "editor"
						and vim.api.nvim_buf_get_name(buf):find("claude", 1, true) ~= nil
				end,
			})
		end,
	},

	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		opts = {
			auto_start = true,
			git_repo_cwd = true,
			terminal = {
				split_side = "right",
				split_width_percentage = 0.4,
				provider = "snacks",
				auto_close = true,
				snacks_win_opts = { title = "Claude Code" },
			},
			diff_opts = {
				layout = "vertical",
				auto_resize_terminal = true,
			},
		},
		keys = {
			{ "<leader>a",  "",                                  desc = "+ai" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>",               desc = "Toggle Claude Code" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>",          desc = "Focus Claude Code" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>",      desc = "Resume Claude Code" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>",    desc = "Continue Claude Code" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>",    desc = "Select model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",          desc = "Add buffer to Claude" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>",           desc = "Send to Claude",         mode = "v" },
			{ "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>",        desc = "Add file (tree)",        ft = { "neo-tree", "oil", "snacks_picker_list" } },
			{ "<leader>aA", "<cmd>ClaudeCodeDiffAccept<cr>",     desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",       desc = "Deny diff" },
		},
	},
}
