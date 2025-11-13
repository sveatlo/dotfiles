local lualine_components = require("plugins.ui.lualine_components")

return {
	require("plugins.ui.bufferline"),
	require("plugins.ui.fzf"),
	require("plugins.ui.edgy"),

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>fp", "<cmd>Neotree reveal toggle<cr>", desc = "Toggle Filetree" },
			{ "<F3>", "<cmd>Neotree reveal toggle<cr>", desc = "Toggle Filetree" },
		},
		opts = {
			-- fill any relevant options here
		},
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"meuter/lualine-so-fancy.nvim",
		},
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		opts = function()
			-- PERF: we don't need this lualine require madness 🤷
			local lualine_require = require("lualine_require")
			lualine_require.require = require

			vim.o.laststatus = vim.g.lualine_laststatus

			local opts = {
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = {},
					section_separators = {},
					disabled_filetypes = {
						statusline = { "alpha", "lazy", "fugitive", "" },
						winbar = {
							"help",
							"alpha",
							"lazy",
						},
					},
					always_divide_middle = true,
					globalstatus = true,
				},
				sections = {
					lualine_a = { { "fancy_mode", width = 6 } },
					lualine_b = { lualine_components.git_repo, "branch" },
					lualine_c = {
						-- { "fancy_cwd", substitute_home = true },
						-- "filename",
						lualine_components.diff,
						{ "fancy_diagnostics" },
						lualine_components.noice_command,
						lualine_components.noice_mode,
						-- { require("NeoComposer.ui").status_recording },
						lualine_components.separator,
						{ "fancy_lsp_servers" },
					},
					lualine_x = { lualine_components.spaces, "encoding", "fileformat", "filetype", "progress" },
					lualine_y = {},
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "nvim-tree", "toggleterm", "quickfix" },
			}

			return opts
		end,
	},

	-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		},
        -- stylua: ignore
        keys = {
            { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
            { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
        },
		config = function(_, opts)
			-- HACK: noice shows messages from before it was enabled,
			-- but this is not ideal when Lazy is installing plugins,
			-- so clear the messages in this case.
			if vim.o.filetype == "lazy" then
				vim.cmd([[messages clear]])
			end
			require("noice").setup(opts)
		end,
	},

	-- icons
	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	-- ui components
	{ "MunifTanjim/nui.nvim", lazy = true },

	{
		"folke/snacks.nvim",
		opts = {
			indent = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = false }, -- we set this in options.lua
			toggle = { enabled = true },
			words = { enabled = true },
		},
        -- stylua: ignore
        keys = {
            { "<leader>nh", function()
                if Snacks.config.picker and Snacks.config.picker.enabled then
                    Snacks.picker.notifications()
                else
                    Snacks.notifier.show_history()
                end
            end, desc = "Notification History" },
            { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
        },
	},

	-- dashboard
	{
		"snacks.nvim",
		event = "VeryLazy",
		opts = {
			dashboard = {
				preset = {
                    -- stylua: ignore
                    ---@type snacks.dashboard.Item[]
                    keys = {
                        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        { icon = " ", key = "t", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
				},
			},
		},
	},

	{
		"folke/twilight.nvim",
		config = true,
		cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
		keys = {
			{ "<leader>ut", "<cmd>Twilight<cr>", desc = "Toggle Twilight (dimming)" },
		},
	},
	{
		"folke/zen-mode.nvim",
		config = true,
		cmd = { "ZenMode" },
		keys = {
			{ "<leader>uz", "<cmd>ZenMode<cr>", desc = "Toggle ZenMode" },
		},
	},
}
