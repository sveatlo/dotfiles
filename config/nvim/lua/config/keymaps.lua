-- more mappings are defined in `lua/config/which.lua`

local map = vim.keymap.set

local default_options = { silent = true }
local expr_options = { expr = true, silent = true }

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
map("v", "<C-C>", '"+y')
map("n", "<C-V>", '"+p')
map("i", "<C-V>", "<Esc><C-v>a")

-- Better viewing
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "g,", "g,zvzz")
map("n", "g;", "g;zvzz")

-- Scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Buffer navigation
map("n", "<C-j>", "<C-w>j", default_options)
map("n", "<C-k>", "<C-w>k", default_options)
map("n", "<C-l>", "<C-w>l", default_options)
map("n", "<C-h>", "<C-w>h", default_options)
--
map("i", "<C-j>", "<C-w>j", default_options)
map("i", "<C-k>", "<C-w>k", default_options)
map("i", "<C-l>", "<C-w>l", default_options)
map("i", "<C-h>", "<C-w>h", default_options)

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Mappings                                                           │
--  ╰────────────────────────────────────────────────────────────────────╯

local wk = require("which-key")

-- non-leader mappings
wk.register({
	-- MISC
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
		d = { "<cmd>bdelete<CR>", "Close Buffer" },
		D = { "<cmd>bdelete!<CR>", "Close! Buffer" },
	},
	f = {
		name = "Files",
		b = { "<cmd>Telescope file_browser<cr>", "File browser" },
		f = {
			"<cmd>lua require'telescope.builtin'.find_files()<cr>",
			"Find File",
		},
		-- p = { "<cmd>NvimTreeToggle<cr>", "Toggle Tree" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		T = { "<cmd>NvimTreeFindFile<CR>", "Find in Tree" },
		z = { "<cmd>Telescope zoxide list<CR>", "Zoxide" },
	},
	m = {
		name = "Misc",
		d = { "<cmd>lua require('core.plugins.lsp.utils').toggle_diagnostics()<cr>", "Toggle Diagnostics" },
		l = { "<cmd>source ~/.config/nvim/snippets/*<cr>", "Reload snippets" },
		p = { "<cmd>Lazy sync<cr>", "Sync plugins" },
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
