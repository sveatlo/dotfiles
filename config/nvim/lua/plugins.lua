local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
function get_config(name)
	return string.format('require("config/%s")', name)
end

-- bootstrap packer if not installed
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({
		"git",
		"clone",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	execute("packadd packer.nvim")
end

-- initialize and configure packer
local packer = require("packer")

packer.init({
	enable = true, -- enable profiling via :PackerCompile profile=true
	threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
})

packer.startup(function(use)
	-- actual plugins list
	use("wbthomason/packer.nvim")

	--------------------
	--     VISUAL     --
	--------------------
	-- theme
	use({ "Shatur/neovim-ayu", config = get_config("ui.ayu") })

	use({ "kyazdani42/nvim-web-devicons" })

	use({
		"nvim-lualine/lualine.nvim",
		config = get_config("ui.lualine"),
		event = "VimEnter",
		requires = { { "kyazdani42/nvim-web-devicons", opt = true } },
	})

	-- better tabs
	use({
		"akinsho/nvim-bufferline.lua",
		requires = { "kyazdani42/nvim-web-devicons" },
		event = "BufReadPre",
		config = get_config("ui.bufferline"),
	})

	-- startup screen
	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = get_config("ui.alpha-nvim"),
	})

	-- popup notifications
	use({ "rcarriga/nvim-notify", config = get_config("ui.notify") })

	-- highlight colour
	use({
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPre",
		ft = { "scss", "css", "html" },
		config = get_config("colorizer"),
	})

	-- highlight word
	use({ "RRethy/vim-illuminate" })

	-- smooth scroll
	use({ "karb94/neoscroll.nvim", config = get_config("ui.neoscroll") })

	-- lsp progress
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	})

	use({ "ray-x/guihua.lua", run = "cd lua/fzy && make" })

	------------------------
	--     NAVIGATION     --
	------------------------
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
		config = get_config("ui.telescope"),
	})
	use({ "jvgrootveld/telescope-zoxide" })
	use({ "crispgm/telescope-heading.nvim" })
	use({ "nvim-telescope/telescope-ui-select.nvim" })
	use({ "nvim-telescope/telescope-symbols.nvim" })
	use({ "nvim-telescope/telescope-file-browser.nvim" })
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope-packer.nvim" })

	use({ "kyazdani42/nvim-tree.lua", config = get_config("ui.nvim-tree") })

	use({ "numToStr/Navigator.nvim", config = get_config("ui.navigator") })

	-- use({ "ggandor/lightspeed.nvim" })

	---------------------
	--       GIT       --
	---------------------
	use({
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
		},
		config = get_config("code.diffview"),
	})

	use({
		"TimUntersberger/neogit",
		requires = { "nvim-lua/plenary.nvim" },
		cmd = "Neogit",
		config = get_config("neogit"),
	})

	use({ "f-person/git-blame.nvim", config = get_config("code.git-blame") })

	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		event = "BufReadPre",
		config = get_config("gitsigns"),
	})

	use({ "rhysd/conflict-marker.vim" })

	----------------------------
	--     CODE / EDITING     --
	----------------------------
	use({
		"nvim-treesitter/nvim-treesitter",
		config = get_config("code.treesitter"),
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"mfussenegger/nvim-ts-hint-textobject",
			"p00f/nvim-ts-rainbow", -- rainbow brackets
		},
	})

	-- LSP
	use({ "neovim/nvim-lspconfig", config = get_config("lsp.lsp") })
	use({ "onsails/lspkind-nvim" })
	use({
		"williamboman/mason.nvim",
		requires = {
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = get_config("lsp.mason"),
	})
	use({
		"lvimuser/lsp-inlayhints.nvim",
		config = get_config("lsp.inlayhints"),
	})

	-- completion
	use({ "zbirenbaum/copilot.lua", config = get_config("code.copilot") })
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "zbirenbaum/copilot-cmp", config = get_config("code.cmp.copilot") },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "f3fora/cmp-spell" },
			{ "hrsh7th/cmp-calc" },
			{ "lukas-reineke/cmp-rg" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
		},
		config = get_config("code.cmp"),
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = get_config("lsp.null-ls"),
	})
	-- show current position in statusline
	use({ "SmiteshP/nvim-navic" })

	use({ "ray-x/go.nvim", config = get_config("go"), ft = { "go" } })
	-- use({ "simrat39/rust-tools.nvim", config = get_config("rust-tools"), ft = { "rust" } })
	use({
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		requires = { "nvim-lua/plenary.nvim" },
		config = get_config("rust-crates"),
	})

	-- symbols outline in side window
	use({
		"simrat39/symbols-outline.nvim",
		-- cmd = { "SymbolsOutline" },
		config = get_config("code.symbols-outline"),
	})

	-- comments
	use({ "numToStr/Comment.nvim", config = get_config("code.comment") })
	use({ "LudoPinelli/comment-box.nvim", config = get_config("code.comment-box") })
	-- highlight todo comments
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = get_config("code.todo"),
	})

	-- snippets
	use({ "rafamadriz/friendly-snippets" })
	use({
		"L3MON4D3/LuaSnip",
		requires = "saadparwaiz1/cmp_luasnip",
		config = get_config("code.luasnip"),
	})

	-- better quick-fix window
	use({
		"kevinhwang91/nvim-bqf",
		requires = { { "junegunn/fzf", module = "nvim-bqf" } },
		ft = "qf",
		config = get_config("code.nvim-bqf"),
	})

	use({ "junegunn/vim-easy-align" }) -- no lua alternative
	use({ "windwp/nvim-autopairs", config = get_config("code.autopairs") })
	use({ "ironhouzi/starlite-nvim" }) -- */# vim command replacement

	use({
		"mfussenegger/nvim-dap",
		config = get_config("dap"),
		requires = {
			{ "rcarriga/nvim-dap-ui" },
			{ "theHamsta/nvim-dap-virtual-text" },
			{ "nvim-telescope/telescope-dap.nvim" },
			{ "mfussenegger/nvim-dap-python" },
			{ "leoluz/nvim-dap-go" },
		},
	})

	------------------
	--     MISC     --
	------------------
	use({ "ahmedkhalf/project.nvim", config = get_config("project") })
	use({ "Shatur/neovim-session-manager", config = get_config("sessions") })
	use({ "folke/which-key.nvim", config = get_config("which") })
	use({ "echasnovski/mini.nvim", branch = "stable", config = get_config("mini") })
	use({ "edluffy/specs.nvim", config = get_config("code.specs") })
	use({ "folke/zen-mode.nvim", cmd = "ZenMode", config = get_config("ui.zen-mode") }) -- zen mode
	use({ "folke/twilight.nvim", config = get_config("ui.twilight") }) -- highlights part of code being worked on in zen mode
	use({ "tweekmonster/startuptime.vim" })
	use({ "rhysd/vim-grammarous", cmd = "GrammarousCheck" })

	use({
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPre",
		config = get_config("code.indent-blankline"),
	})

	use({
		"ThePrimeagen/harpoon",
		requires = { "nvim-lua/plenary.nvim" },
		config = get_config("harpoon"),
	})
end)
