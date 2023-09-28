return {
	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
	{
		"nvim-tree/nvim-web-devicons",
		dependencies = { "DaikyXendo/nvim-material-icon" },
		config = function()
			require("nvim-web-devicons").setup({
				override = require("nvim-material-icon").get_icons(),
			})
		end,
	},
	{ "yamatsum/nvim-nonicons", enabled = false, config = true },
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{ "nacro90/numb.nvim", event = "BufReadPre", config = true },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		opts = {
			-- background_colour = "#A3CCBE",
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
		},
		config = function(_, opts)
			require("notify").setup(opts)
			vim.notify = require("notify")
		end,
	},
	{
		"monaqa/dial.nvim",
		keys = {
			{ "<C-a>", mode = { "n", "v" } },
			{ "<C-x>", mode = { "n", "v" } },
			{ "g<C-a>", mode = { "v" } },
			{ "g<C-x>", mode = { "v" } },
		},
        -- stylua: ignore
        init = function()
            vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(),
                { desc = "Increment", noremap = true })
            vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(),
                { desc = "Decrement", noremap = true })
            vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(),
                { desc = "Increment", noremap = true })
            vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(),
                { desc = "Decrement", noremap = true })
            vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(),
                { desc = "Increment", noremap = true })
            vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(),
                { desc = "Decrement", noremap = true })
        end,
	},
	{
		"andymass/vim-matchup",
		event = { "BufReadPost" },
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	{
		"kylechui/nvim-surround",
		event = "BufReadPre",
		opts = {},
	},
	-- session management
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Current Session",
			},
		},
	},
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup({
				mapping = { "jk" },
			})
		end,
	},
	{
		"TheBlob42/houdini.nvim",
		enabled = false,
		event = "VeryLazy",
		opts = {
			escape_sequences = {
				["t"] = "<ESC>",
				["c"] = "<ESC>",
			},
		},
	},
}
