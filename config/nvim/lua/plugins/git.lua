local utils = require("utils")

return {
	-- Ensure GitUI tool is installed
	{
		"mason-org/mason.nvim",
		opts = { ensure_installed = { "gitui" } },
		keys = {
			{
				"<leader>gG",
				function()
					Snacks.terminal({ "gitui" })
				end,
				desc = "GitUi (cwd)",
			},
			{
				"<leader>gg",
				function()
					Snacks.terminal({ "gitui" }, { cwd = utils.get_root() })
				end,
				desc = "GitUi (Root Dir)",
			},
		},
		init = function()
			-- delete lazygit keymap for file history
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimKeymaps",
				once = true,
				callback = function()
					pcall(vim.keymap.del, "n", "<leader>gf")
					pcall(vim.keymap.del, "n", "<leader>gl")
				end,
			})
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "▸" },
				topdelete = { text = "▾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			-- update_debounce = 100,
            -- stylua: ignore
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
				map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
				map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
				map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
				map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage Buffer" })
				map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset Buffer" })
				map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Blame Line" })
				map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
				map("n", "<leader>gd", gs.diffthis, { desc = "Diff This" })
				map("n", "<leader>gD", function() gs.diffthis("~") end, { desc = "Diff This ~" })
				map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle Delete" })
				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
			end,
		},
	},
}
