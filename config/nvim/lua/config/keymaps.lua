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
map("v", "p", '"_dp', default_options) -- doesn't work with yanky

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
