local icons = require("config.icons")
return {
	-- yank history
	{
		"gbprod/yanky.nvim",
		dependencies = { "folke/snacks.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			highlight = { timer = 150 },
		},
		keys = {
			{
				"<leader>p",
				"<cmd>YankyRingHistory<cr>",
				mode = { "n", "x" },
				desc = "Open Yank History",
			},
            -- stylua: ignore
            { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
			{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" },
			{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" },
			{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" },
			{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" },
			{ "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
			{ "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
			{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
			{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
			{ "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
			{ "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
			{ ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
			{ "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
			{ ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
			{ "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
			{ "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
			{ "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
		},
	},
	-- project management, automatic cwd
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
	-- search/replace in multiple files
	{
		"MagicDuck/grug-far.nvim",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
	},

	{
		"echasnovski/mini.surround",
		event = "VeryLazy",
		opts = {
			-- Number of lines within which surrounding is searched
			n_lines = 50,

			-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
			highlight_duration = 500,

			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				add = "sa", -- Add surrounding
				delete = "sd", -- Delete surrounding
				find = "sf", -- Find surrounding (to the right)
				find_left = "sF", -- Find surrounding (to the left)
				highlight = "sh", -- Highlight surrounding
				replace = "sr", -- Replace surrounding
				update_n_lines = "sn", -- Update `n_lines`
			},
		},
	},

	{
		"andymass/vim-matchup",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},

	{
		"ggandor/leap.nvim",
		enabled = true,
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
			{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
			vim.keymap.del({ "x", "o" }, "x")
			vim.keymap.del({ "x", "o" }, "X")

			-- 1-character search (enhanced f/t motions)
			-- ref: https://github.com/ggandor/leap.nvim/blob/f5fe479e20d809df7b54ad53142c2bdb0624c62a/README.md?plain=1#L695
			do
				-- Returns an argument table for `leap()`, tailored for f/t-motions.
				local function as_ft(key_specific_args)
					local common_args = {
						inputlen = 1,
						inclusive = true,
						-- To limit search scope to the current line:
						-- pattern = function (pat) return '\\%.l'..pat end,
						opts = {
							labels = "", -- force autojump
							safe_labels = vim.fn.mode(1):match("o") and "" or nil, -- [1]
							case_sensitive = true, -- [2]
						},
					}
					return vim.tbl_deep_extend("keep", common_args, key_specific_args)
				end

				local clever = require("leap.user").with_traversal_keys -- [3]
				local clever_f = clever("f", "F")
				local clever_t = clever("t", "T")

				for key, args in pairs({
					f = { opts = clever_f },
					F = { backward = true, opts = clever_f },
					t = { offset = -1, opts = clever_t },
					T = { backward = true, offset = 1, opts = clever_t },
				}) do
					vim.keymap.set({ "n", "x", "o" }, key, function()
						require("leap").leap(as_ft(args))
					end)
				end
			end

			------------------------------------------------------------------------
			-- [1] Match the modes here for which you don't want to use labels
			--     (`:h mode()`, `:h lua-pattern`).
			-- [2] For 1-char search, you might want to aim for precision instead of
			--     typing comfort, to get as many direct jumps as possible.
			-- [3] This helper function makes it easier to set "clever-f"-like
			--     functionality (https://github.com/rhysd/clever-f.vim), returning
			--     an `opts` table derived from the defaults, where:
			--     * the given keys are added to `keys.next_target` and
			--       `keys.prev_target`
			--     * the forward key is used as the first label in `safe_labels`
			--     * the backward (reverse) key is removed from `safe_labels`
		end,
	},

	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		opts = {
			modes = {
				lsp = {
					win = { position = "right" },
				},
			},
		},
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
			{ "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Previous Trouble/Quickfix Item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next Trouble/Quickfix Item",
			},
		},
	},

	-- Finds and lists all of the TODO, HACK, BUG, etc comment
	-- in your project and loads them into a browsable list.
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = "VeryLazy",
		opts = {},
        -- stylua: ignore
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
            { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
            { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
            { "<leader>sT", "<cmd>TodoFzfLua<cr>", desc = "Todo" },
        },
	},

	{
		"numToStr/Comment.nvim",
		keys = {
			{
				"<leader>cc",
				"<cmd>lua require('Comment.api').toggle.linewise(motion, cfg)<CR>",
				mode = "n",
				desc = "Comment line",
			},
			{
				"<leader>cc",
				"<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
				mode = "x",
				desc = "Comment line",
			},
		},
		config = function()
			require("Comment").setup({
				---Add a space b/w comment and the line
				---@type boolean|fun():boolean
				padding = true,

				---Whether the cursor should stay at its position
				---NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
				---@type boolean
				sticky = true,

				---Lines to be ignored while comment/uncomment.
				---Could be a regex string or a function that returns a regex string.
				---Example: Use '^$' to ignore empty lines
				---@type string|fun():string
				ignore = nil,

				---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
				---NOTE: If `mappings = false` then the plugin won't create any mappings
				---@type boolean|table
				mappings = false,
			})
		end,
	},

	{
		"saghen/blink.cmp",
		build = "cargo build --release",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
			"sources.default",
		},
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				dependencies = { "rafamadriz/friendly-snippets" },
			},
			"saghen/blink.compat",
		},
		event = "InsertEnter",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			snippets = { preset = "luasnip" },
			appearance = {
				-- sets the fallback highlight groups to nvim-cmp's highlight groups
				-- useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release, assuming themes add support
				use_nvim_cmp_as_default = true,
				-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
				kind_icons = icons.kind,
			},
			completion = {
				accept = {
					-- experimental auto-brackets support
					auto_brackets = {
						enabled = true,
					},
				},
				list = {
					selection = { preselect = false },
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = {
					enabled = false,
				},
			},

			-- cmdline completion
			cmdline = {
				keymap = {
					-- preset = "inherit" ,

					["<Tab>"] = { "show_and_insert", "select_next" },
					["<S-Tab>"] = { "show_and_insert", "select_prev" },

					["<C-space>"] = { "show", "fallback" },

					["<C-n>"] = { "select_next", "fallback" },
					["<C-p>"] = { "select_prev", "fallback" },
					["<Right>"] = { "select_next", "fallback" },
					["<Left>"] = { "select_prev", "fallback" },

					["<C-y>"] = { "select_and_accept" },
					["<C-e>"] = { "cancel" },
				},
				completion = {
					list = {
						selection = { preselect = false },
					},
					ghost_text = { enabled = false },
					menu = { auto_show = true },
				},
			},

			-- experimental signature help support
			-- signature = { enabled = true },

			sources = {
				-- adding any nvim-cmp sources here will enable them
				-- with blink.compat
				compat = {},
				default = { "lsp", "path", "snippets", "buffer" },
			},

			keymap = {
				preset = "enter",
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<C-y>"] = { "select_and_accept" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		---@param opts blink.cmp.Config | { sources: { compat: string[] } }
		config = function(_, opts)
			-- setup compat sources
			local enabled = opts.sources.default
			for _, source in ipairs(opts.sources.compat or {}) do
				opts.sources.providers[source] = vim.tbl_deep_extend(
					"force",
					{ name = source, module = "blink.compat.source" },
					opts.sources.providers[source] or {}
				)
				if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
					table.insert(enabled, source)
				end
			end

			opts.sources.compat = nil

			-- check if we need to override symbol kinds
			for _, provider in pairs(opts.sources.providers or {}) do
				---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
				if provider.kind then
					local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
					local kind_idx = #CompletionItemKind + 1

					CompletionItemKind[kind_idx] = provider.kind
					---@diagnostic disable-next-line: no-unknown
					CompletionItemKind[provider.kind] = kind_idx

					---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
					local transform_items = provider.transform_items
					---@param ctx blink.cmp.Context
					---@param items blink.cmp.CompletionItem[]
					provider.transform_items = function(ctx, items)
						items = transform_items and transform_items(ctx, items) or items
						for _, item in ipairs(items) do
							item.kind = kind_idx or item.kind
							item.kind_icon = icons.kinds[item.kind_name] or item.kind_icon or nil
						end
						return items
					end

					-- Unset custom prop to pass blink.cmp validation
					provider.kind = nil
				end
			end

			require("blink.cmp").setup(opts)
		end,
	},

	{
		"max397574/better-escape.nvim",
		event = "VeryLazy",
		config = function()
			require("better_escape").setup()
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
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				-- default augends used when no group name is specified
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.constant.alias.bool,
					augend.date.alias["%Y/%m/%d"],
					augend.semver.alias.semver,
				},
			})
		end,
	},
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		event = "VeryLazy",
            -- stylua: ignore
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			local set = vim.keymap.set

			-- Add or skip cursor above/below the main cursor.
			set({ "n", "x" }, "<A-up>", function() mc.lineAddCursor(-1) end)
			set({ "n", "x" }, "<A-down>", function() mc.lineAddCursor(1) end)
			set({ "n", "x" }, "<A-S-up>", function() mc.lineSkipCursor(-1) end)
			set({ "n", "x" }, "<A-S-down>", function() mc.lineSkipCursor(1) end)

			-- Add or skip adding a new cursor by matching word/selection
			set({ "n", "x" }, "<A-S-d>", function() mc.matchAddCursor(1) end)

            set("n", "<A-leftmouse>", mc.handleMouse)
            set("n", "<A-leftdrag>", mc.handleMouseDrag)
            set("n", "<A-leftrelease>", mc.handleMouseRelease)

            -- Pressing `gaip` will add a cursor on each line of a paragraph.
            set("n", "ga", mc.addCursorOperator)

            -- Increment/decrement sequences, treating all cursors as one sequence.
            set({"n", "x"}, "g<c-a>", mc.sequenceIncrement)
            set({"n", "x"}, "g<c-x>", mc.sequenceDecrement)


            mc.addKeymapLayer(function(layerSet)
                -- Enable and clear cursors using escape.
                layerSet("n", "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
            end)
		end,
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		event = "VeryLazy",
		lazy = false,
	},
}
