local swap_next, swap_prev = (function()
	local swap_objects = {
		p = "@parameter.inner",
		f = "@function.outer",
		c = "@class.outer",
	}
	local n, p = {}, {}
	for key, obj in pairs(swap_objects) do
		n[string.format("<leader>lx%s", key)] = obj
		p[string.format("<leader>lX%s", key)] = obj
	end
	return n, p
end)()

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"bash",
				"dockerfile",
				"html",
				"markdown",
				"markdown_inline",
				"query",
				"regex",
				"latex",
				"vim",
				"vimdoc",
				"yaml",
			},
		},
		config = function(_, opts)
			local parsers = require("utils").dedup(opts.ensure_installed or {})
			require("nvim-treesitter").install(parsers)

			-- Enable treesitter highlighting for all filetypes that have a parser
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})

			local sel = require("nvim-treesitter-textobjects.select")
			for key, query in pairs({
				aa = "@parameter.outer", ia = "@parameter.inner",
				af = "@function.outer",  ["if"] = "@function.inner",
				ac = "@class.outer",     ic = "@class.inner",
			}) do
				vim.keymap.set({ "x", "o" }, key, function()
					sel.select_textobject(query, "textobjects")
				end)
			end

			local move = require("nvim-treesitter-textobjects.move")
			for key, args in pairs({
				["]m"]  = { move.goto_next_start,     "@function.outer" },
				["]]"]  = { move.goto_next_start,     "@class.outer" },
				["]M"]  = { move.goto_next_end,       "@function.outer" },
				["]["]  = { move.goto_next_end,       "@class.outer" },
				["[m"]  = { move.goto_previous_start, "@function.outer" },
				["[["]  = { move.goto_previous_start, "@class.outer" },
				["[M"]  = { move.goto_previous_end,   "@function.outer" },
				["[]"]  = { move.goto_previous_end,   "@class.outer" },
			}) do
				vim.keymap.set({ "n", "x", "o" }, key, function()
					args[1](args[2], "textobjects")
				end)
			end

			local swap = require("nvim-treesitter-textobjects.swap")
			for key, query in pairs(swap_next) do
				vim.keymap.set("n", key, function() swap.swap_next(query) end)
			end
			for key, query in pairs(swap_prev) do
				vim.keymap.set("n", key, function() swap.swap_previous(query) end)
			end
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		opts = {},
	},
}
