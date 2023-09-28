local M = {
	"akinsho/nvim-bufferline.lua",
	event = "BufReadPre",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		-- bufferline tab management
		{ "<C-Pageup>", "<cmd>BufferLineCyclePrev<CR>", desc = "Next tab" },
		{ "<C-PageDown>", "<cmd>BufferLineCycleNext<CR>", desc = "Previous tab" },
		{ "<C-A-Pageup>", "<cmd>BufferLineMovePrev<CR>", desc = "Move tab left" },
		{ "<C-A-PageDown>", "<cmd>BufferLineMoveNext<CR>", desc = "Move tab right" },
		{ "<C-t>", "<cmd>enew<CR>", desc = "Open new tab" },
		{ "<C-q>", "<cmd>bdelete<CR>", desc = "Close tab" },
		{ "<A-1>", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to tab no. 1" },
		{ "<A-2>", "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to tab no. 2" },
		{ "<A-3>", "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to tab no. 3" },
		{ "<A-4>", "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to tab no. 4" },
		{ "<A-5>", "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to tab no. 5" },
		{ "<A-6>", "<Cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to tab no. 6" },
		{ "<A-7>", "<Cmd>BufferLineGoToBuffer 7<CR>", desc = "Go to tab no. 7" },
		{ "<A-8>", "<Cmd>BufferLineGoToBuffer 8<CR>", desc = "Go to tab no. 8" },
		{ "<A-9>", "<Cmd>BufferLineGoToBuffer 9<CR>", desc = "Go to tab no. 9" },
		-- Tab switch buffer
		{ "<TAB>", "<cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
		{ "<S-TAB>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous tab" },
	},
	config = function()
		local utils = require("utils")
		local icons = require("config.icons")
		require("bufferline").setup({
			options = {
				mode = "buffers",
				numbers = function(opts)
					return string.format("%s", opts.ordinal) -- :h bufferline-numbers
				end,
				close_command = utils.bufdelete, -- can be a string | function, see "Mouse actions"
				right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
				left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
				middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
				indicator = {
					style = "icon",
					icon = " ",
				},
				buffer_close_icon = icons.ui.Close,
				modified_icon = icons.ui.Circle,
				close_icon = icons.ui.BoldClose,
				left_trunc_marker = icons.ui.DividerLeft,
				right_trunc_marker = icons.ui.DividerRight,
				max_name_length = 18,
				max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
				tab_size = 20,
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level)
					local icon = level:match("error") and (icons.diagnostics.Error .. " ") or (icons.diagnostics.Warning .. " ")
					return " " .. icon .. count
				end,
				custom_filter = function(buf_number, _)
					-- filter out filetypes you don't want to see
					if vim.bo[buf_number].filetype ~= "qf" then
						return true
					end
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = " File Explorer",
						highlight = "Directory",
						text_align = "left",
						padding = 0,
					},
				},
				show_buffer_icons = true, -- disable filetype icons for buffers
				show_buffer_close_icons = false,
				show_close_icon = false,
				show_tab_indicators = false,
				persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
				-- can also be a table containing 2 custom separators
				-- [focused and unfocused]. eg: { '|', '|' }
				separator_style = "slant",
				-- enforce_regular_tabs = true,
				always_show_bufferline = true,
				sort_by = "id",
			},
		})
	end,
}

return M
