-- more mappings are defined in `lua/config/which.lua`

local map = vim.keymap.set

default_options = { silent = true }
expr_options = { expr = true, silent = true }

--Remap space as leader key
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = ","

--Remap for dealing with visual line wraps
map("n", "k", "v:count == 0 ? 'gk' : 'k'", expr_options)
map("n", "j", "v:count == 0 ? 'gj' : 'j'", expr_options)

-- better indenting
map("v", "<", "<gv", default_options)
map("v", ">", ">gv", default_options)

-- paste over currently selected text without yanking it
map("v", "p", '"_dP', default_options)

-- Cancel search highlighting with ESC
map("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", default_options)

-- Move selected line / block of text in visual mode
map("x", "K", ":move '<-2<CR>gv-gv", default_options)
map("x", "J", ":move '>+1<CR>gv-gv", default_options)

-- move over a closing element in insert mode
map("i", "<C-l>", function()
	return require("utils").escapePair()
end, default_options)

-- replace highlighted word
map("v", "<C-r>", '"hy:%s/<C-r>h//gc<left><left><left>')

-- Ctrl+C & Ctrl+V
map("v", "<C-c>", "y")
map("n", "<C-v>", "p")
map("i", "<C-v>", "<Esc><C-v>a")

-- starlite mappings
map("n", "*", function()
	return require("starlite").star()
end, default_options)
map("n", "g*", function()
	return require("starlite").g_star()
end, default_options)
map("n", "#", function()
	return require("starlite").hash()
end, default_options)
map("n", "g#", function()
	return require("starlite").g_hash()
end, default_options)

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Mappings                                                           │
--  ╰────────────────────────────────────────────────────────────────────╯

local wk = require("which-key")

-- non-leader mappings
wk.register({
	-- bufferline tab management
	["<C-Pageup>"] = { "<cmd>BufferLineCyclePrev<CR>", "Next tab" },
	["<C-PageDown>"] = { "<cmd>BufferLineCycleNext<CR>", "Previous tab" },
	["<C-A-Pageup>"] = { "<cmd>BufferLineMovePrev<CR>", "Move tab left" },
	["<C-A-PageDown>"] = { "<cmd>BufferLineMoveNext<CR>", "Move tab right" },
	["<C-t>"] = { "<cmd>enew<CR>", "Open new tab" },
	["<C-q>"] = { "<cmd>bdelete<CR>", "Close tab" },
	["<A-1>"] = { "<Cmd>BufferLineGoToBuffer 1<CR>", "Go to tab no. 1" },
	["<A-2>"] = { "<Cmd>BufferLineGoToBuffer 2<CR>", "Go to tab no. 2" },
	["<A-3>"] = { "<Cmd>BufferLineGoToBuffer 3<CR>", "Go to tab no. 3" },
	["<A-4>"] = { "<Cmd>BufferLineGoToBuffer 4<CR>", "Go to tab no. 4" },
	["<A-5>"] = { "<Cmd>BufferLineGoToBuffer 5<CR>", "Go to tab no. 5" },
	["<A-6>"] = { "<Cmd>BufferLineGoToBuffer 6<CR>", "Go to tab no. 6" },
	["<A-7>"] = { "<Cmd>BufferLineGoToBuffer 7<CR>", "Go to tab no. 7" },
	["<A-8>"] = { "<Cmd>BufferLineGoToBuffer 8<CR>", "Go to tab no. 8" },
	["<A-9>"] = { "<Cmd>BufferLineGoToBuffer 9<CR>", "Go to tab no. 9" },
	-- Tab switch buffer
	["<TAB>"] = { "<cmd>BufferLineCycleNext<CR>", "Next tab" },
	["<S-TAB>"] = { "<cmd>BufferLineCyclePrev<CR>", "Previous tab" },

	-- code/LSP
	K = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show help" },
	["<F2>"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
	["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Previous diagnostic error" },
	["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next diagnostic error" },

	-- MISC
	["<F3>"] = { ":NvimTreeToggle<CR>", "Open file tree" },
	ga = { "<Plug>(EasyAlign)", "Align", mode = "x" },
	ss = { "<Plug>Lightspeed_s", "Search 2-character forward" },
	["<C-p>"] = { "<cmd>lua require'telescope.builtin'.find_files()<cr>", "Find File" },
}, {})

-- leader-base mappings in normal mode
wk.register({
	b = {
		name = "Buffers",
		["?"] = {
			"<cmd>Telescope buffers<cr>",
			"Find buffer",
		},
		d = { "<cmd>Bdelete!<CR>", "Close Buffer" },
	},
	f = {
		name = "Files",
		b = { "<cmd>Telescope file_browser<cr>", "File browser" },
		f = {
			"<cmd>lua require'telescope.builtin'.find_files()<cr>",
			"Find File",
		},
		p = { "<cmd>NvimTreeToggle<cr>", "Toggle Tree" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		T = { "<cmd>NvimTreeFindFile<CR>", "Find in Tree" },
		z = { "<cmd>Telescope zoxide list<CR>", "Zoxide" },
	},
	m = {
		name = "Misc",
		d = { "<cmd>lua require('utils').toggle_diagnostics()<cr>", "Toggle Diagnostics" },
		l = { "<cmd>source ~/.config/nvim/snippets/*<cr>", "Reload snippets" },
		p = { "<cmd>PackerSync<cr>", "PackerSync" },
		z = { "<cmd>ZenMode<cr>", "Toggle ZenMode" },
	},
	s = {
		name = "Search",
		C = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
		H = { "<cmd>Telescope heading<cr>", "Find Header" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		t = { "<cmd>Telescope live_grep<cr>", "Text" },
		T = { "<cmd>Telescope grep_string<cr>", "Text under cursor" },
		s = { "<cmd>SessionManager load_session<cr>", "Sessions" },
		S = { "<cmd>Telescope symbols<cr>", "Search symbols" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		c = { "<cmd>Telescope commands<cr>", "Commands" },
		p = { "<cmd>Telescope projects<cr>", "Projects" },
		P = {
			"<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
			"Colorscheme with Preview",
		},
		z = { "<cmd>Telescope packer<cr>", "Plugins" },
	},
	t = {
		name = "Tabs",
		n = { ":tabn<CR>", "Next tab" },
		p = { ":tabp<CR>", "Previous tab" },
		e = { ":tabe<CR>", "New tab" },
		c = { ":tabclose<CR>", "Close tab" },
	},
	w = {
		name = "Window",
		p = { "<c-w>x", "Swap" },
		q = { "<cmd>:q<cr>", "Close" },
		s = { "<cmd>:split<cr>", "Horizontal Split" },
		t = { "<c-w>t", "Move to new tab" },
		["="] = { "<c-w>=", "Equally size" },
		v = { "<cmd>:vsplit<cr>", "Verstical Split" },
		w = {
			"<cmd>lua require('nvim-window').pick()<cr>",
			"Choose window to jump",
		},
	},
}, { prefix = "<leader>", mode = "n", default_options })
