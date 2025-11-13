return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	keys = {
		{ "<C-Pageup>", "<cmd>BufferLineCyclePrev<CR>", desc = "Next buffer" },
		{ "<C-PageDown>", "<cmd>BufferLineCycleNext<CR>", desc = "Previous buffer" },
		{ "<C-A-Pageup>", "<cmd>BufferLineMovePrev<CR>", desc = "Move buffer left" },
		{ "<C-A-PageDown>", "<cmd>BufferLineMoveNext<CR>", desc = "Move buffer right" },
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "<S-TAB>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<TAB>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
		{ "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
		{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
		{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
		{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
		{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
		{ "<C-t>", "<cmd>enew<CR>", desc = "Open new tab" },
        -- stylua: ignore
		{ "<C-q>", function(n) Snacks.bufdelete(n) end, desc = "Close tab" },

		{ "<A-1>", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to tab no. 1" },
		{ "<A-2>", "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to tab no. 2" },
		{ "<A-3>", "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to tab no. 3" },
		{ "<A-4>", "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to tab no. 4" },
		{ "<A-5>", "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to tab no. 5" },
		{ "<A-6>", "<Cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to tab no. 6" },
		{ "<A-7>", "<Cmd>BufferLineGoToBuffer 7<CR>", desc = "Go to tab no. 7" },
		{ "<A-8>", "<Cmd>BufferLineGoToBuffer 8<CR>", desc = "Go to tab no. 8" },
		{ "<A-9>", "<Cmd>BufferLineGoToBuffer 9<CR>", desc = "Go to tab no. 9" },
	},
	opts = {
		options = {
			numbers = function(opts)
				return string.format("%s", opts.ordinal) -- :h bufferline-numbers
			end,
            -- stylua: ignore
			close_command = function(n) Snacks.bufdelete(n) end,
            -- stylua: ignore
			right_mouse_command = function(n) Snacks.bufdelete(n) end,
			diagnostics = "nvim_lsp",
			always_show_bufferline = true,
			diagnostics_indicator = function(_, _, diag)
				local icons = require("config.icons")
				local ret = (diag.error and icons.diagnostics.Error .. diag.error .. " " or "")
					.. (diag.warning and icons.diagnostics.Warning .. diag.warning or "")
				return vim.trim(ret)
			end,
			offsets = {
				{
					filetype = "neo-tree",
					text = "Neo-tree",
					highlight = "Directory",
					text_align = "left",
				},
				{
					filetype = "snacks_layout_box",
				},
			},
			separator_style = "slant",
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)
		-- Fix bufferline when restoring a session
		vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
			callback = function()
				vim.schedule(function()
					pcall(nvim_bufferline)
				end)
			end,
		})
	end,
}
