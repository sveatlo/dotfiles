return {
	{
		"echasnovski/mini.map",
		opts = {},
		keys = {
            --stylua: ignore
            { "<leader>vm", function() require("mini.map").toggle {} end, desc = "Toggle Minimap", },
		},
		config = function(_, opts)
			require("mini.map").setup(opts)
		end,
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
		"echasnovski/mini.ai",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
			if require("utils").has("which-key.nvim") then
				---@type table<string, string|table>
				local i = {
					[" "] = "Whitespace",
					['"'] = 'Balanced "',
					["'"] = "Balanced '",
					["`"] = "Balanced `",
					["("] = "Balanced (",
					[")"] = "Balanced ) including white-space",
					[">"] = "Balanced > including white-space",
					["<lt>"] = "Balanced <",
					["]"] = "Balanced ] including white-space",
					["["] = "Balanced [",
					["}"] = "Balanced } including white-space",
					["{"] = "Balanced {",
					["?"] = "User Prompt",
					_ = "Underscore",
					a = "Argument",
					b = "Balanced ), ], }",
					c = "Class",
					f = "Function",
					o = "Block, conditional, loop",
					q = "Quote `, \", '",
					t = "Tag",
				}
				local a = vim.deepcopy(i)
				for k, v in pairs(a) do
					a[k] = v:gsub(" including.*", "")
				end

				local ic = vim.deepcopy(i)
				local ac = vim.deepcopy(a)
				for key, name in pairs({ n = "Next", l = "Last" }) do
					i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
					a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
				end
				require("which-key").register({
					mode = { "o", "x" },
					i = i,
					a = a,
				})
			end
		end,
	},
	{
		"echasnovski/mini.bufremove",
		keys = {
			{ "<leader>br", "<cmd>e!<cr>", desc = "Reload Buffer" },
			{ "<leader>bc", "<cmd>close<cr>", desc = "Close Buffer" },
			{
				"<leader>bd",
				function()
					require("mini.bufremove").delete(0, false)
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>bD",
				function()
					require("mini.bufremove").delete(0, true)
				end,
				desc = "Delete Buffer (Force)",
			},
		},
	},
	{
		"echasnovski/mini.animate",
		enabled = false,
		event = "VeryLazy",
		config = function(_, _)
			require("mini.animate").setup()
		end,
	},
	{
		"echasnovski/mini.indentscope",
		enabled = false,
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "help", "alpha", "dashboard", "NvimTree", "Trouble", "lazy", "mason" },
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
		config = function(_, opts)
			require("mini.indentscope").setup(opts)
		end,
	},
	{
		"echasnovski/mini.misc",
		config = true,
		keys = {
			{
				"<leader>vz",
				function()
					require("mini.misc").zoom()
				end,
				desc = "Toggle Zoom",
			},
		},
	},
	{
		"echasnovski/mini.bracketed",
		event = "VeryLazy",
		config = function()
			require("mini.bracketed").setup()
		end,
	},
	{
		"echasnovski/mini.files",
		opts = {},
		keys = {
			{
				"<leader>fE",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
				end,
				desc = "Explorer (Current File)",
			},
			{
				"<leader>fe",
				function()
					require("mini.files").open(vim.loop.cwd(), true)
				end,
				desc = "Explorer (Current Directory)",
			},
		},
		config = function(_, opts)
			require("mini.files").setup(opts)

			local show_dotfiles = true
			local filter_show = function(fs_entry)
				return true
			end
			local filter_hide = function(fs_entry)
				return not vim.startswith(fs_entry.name, ".")
			end

			local toggle_dotfiles = function()
				show_dotfiles = not show_dotfiles
				local new_filter = show_dotfiles and filter_show or filter_hide
				require("mini.files").refresh({ content = { filter = new_filter } })
			end

			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesBufferCreate",
				callback = function(args)
					local buf_id = args.data.buf_id
					-- Tweak left-hand side of mapping to your liking
					vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
				end,
			})
		end,
	},
	{
		"echasnovski/mini.hipatterns",
		event = "BufReadPre",
		opts = function()
			local hi = require("mini.hipatterns")
			return {
				highlighters = {
					hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
				},
			}
		end,
	},
	{
		"echasnovski/mini.operators",
		event = "VeryLazy",
		opts = {
			-- Evaluate text and replace with output
			evaluate = {
				prefix = "g=",
				func = nil,
			},

			-- Exchange text regions
			exchange = {
				prefix = "gx",
				reindent_linewise = true,
			},

			-- Multiply (duplicate) text
			multiply = {
				prefix = "gm",
			},

			-- Replace text with register
			replace = {
				prefix = "gR",
				reindent_linewise = true,
			},

			-- Sort text
			sort = {
				prefix = "gs",
				func = nil,
			},
		},
	},
}
