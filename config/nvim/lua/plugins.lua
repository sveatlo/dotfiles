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
	use({ "Shatur/neovim-ayu", config = get_config("ayu") })

	use({
		"nvim-lualine/lualine.nvim",
		config = get_config("lualine"),
		event = "VimEnter",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- better tabs
	use({
		"akinsho/nvim-bufferline.lua",
		requires = "kyazdani42/nvim-web-devicons",
		event = "BufReadPre",
		config = get_config("bufferline"),
	})

	-- startup screen
	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = get_config("alpha-nvim"),
	})

	use({ "rcarriga/nvim-notify", config = get_config("notify") })

	-- highlight colour
	use({
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPre",
		config = get_config("colorizer"),
	})

	-- rainbow brackets
	use("p00f/nvim-ts-rainbow")

	-- highlight word
	use({ "RRethy/vim-illuminate" })

	-- smooth scroll
	use({ "karb94/neoscroll.nvim", config = get_config("neoscroll") })

	-- shows current position in objects in statusline
	use({
		"SmiteshP/nvim-gps",
		config = function()
			require("nvim-gps").setup({})
		end,
	})

	-- lsp progress
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	})

	------------------------
	--     NAVIGATION     --
	------------------------
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
		config = get_config("telescope"),
	})
	use({ "jvgrootveld/telescope-zoxide" })
	use({ "crispgm/telescope-heading.nvim" })
	use({ "nvim-telescope/telescope-ui-select.nvim" })
	use({ "nvim-telescope/telescope-symbols.nvim" })
	use({ "nvim-telescope/telescope-file-browser.nvim" })
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope-packer.nvim" })

	use({ "kyazdani42/nvim-tree.lua", config = get_config("nvim-tree") })

	use({ "numToStr/Navigator.nvim", config = get_config("navigator") })

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
		config = get_config("diffview"),
	})

	use({
		"TimUntersberger/neogit",
		requires = { "nvim-lua/plenary.nvim" },
		cmd = "Neogit",
		config = get_config("neogit"),
	})

	use({ "f-person/git-blame.nvim", config = get_config("git-blame") })

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
		config = get_config("treesitter"),
		run = ":TSUpdate",
	})
	use({ "nvim-treesitter/nvim-treesitter-textobjects" })
	use({ "mfussenegger/nvim-ts-hint-textobject" })

	-- LSP
	use({ "williamboman/nvim-lsp-installer" })
	use({ "neovim/nvim-lspconfig", config = get_config("lsp") })
	use({ "glepnir/lspsaga.nvim", config = get_config("lspsaga") })
	use({
		"ray-x/lsp_signature.nvim",
		require = { "neovim/nvim-lspconfig" },
		config = get_config("lsp-signature"),
	})
	use({ "onsails/lspkind-nvim" })

	-- completion
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "f3fora/cmp-spell", { "hrsh7th/cmp-calc" }, { "lukas-reineke/cmp-rg" } },
		},
		config = get_config("cmp"),
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = get_config("null-ls"),
	})

	use({ "ray-x/go.nvim", config = get_config("go"), ft = { "go" } })

	-- symbols outline in side window
	use({
		"simrat39/symbols-outline.nvim",
		cmd = { "SymbolsOutline" },
		config = get_config("symbols"),
	})

	-- comments
	use({ "numToStr/Comment.nvim", config = get_config("comment") })
	use({ "LudoPinelli/comment-box.nvim", config = get_config("comment-box") })
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = get_config("todo"),
	})

	-- snippets
	use({ "rafamadriz/friendly-snippets" })
	use({
		"L3MON4D3/LuaSnip",
		requires = "saadparwaiz1/cmp_luasnip",
		config = get_config("luasnip"),
	})

	-- better quick-fix window
	use({
		"kevinhwang91/nvim-bqf",
		requires = { { "junegunn/fzf", module = "nvim-bqf" }, config = get_config("nvim-bqf") },
	})

	use({ "junegunn/vim-easy-align" }) -- no lua alternative
	use({ "windwp/nvim-autopairs", config = get_config("autopairs") })
	use({ "ironhouzi/starlite-nvim" }) -- */# vim command replacement

	------------------
	--     MISC     --
	------------------
	use({ "ahmedkhalf/project.nvim", config = get_config("project") })
	use({ "Shatur/neovim-session-manager", config = get_config("sessions") })
	use({ "folke/which-key.nvim", config = get_config("which") })
	use({ "echasnovski/mini.nvim", branch = "stable", config = get_config("mini") })
	use({ "edluffy/specs.nvim", config = get_config("specs") })
	use({ "tweekmonster/startuptime.vim" })
	use({ "rhysd/vim-grammarous", cmd = "GrammarousCheck" })

	use({
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPre",
		config = get_config("indent-blankline"),
	})

	use({
		"ThePrimeagen/harpoon",
		requires = { "nvim-lua/plenary.nvim" },
		config = get_config("harpoon"),
	})
end)
