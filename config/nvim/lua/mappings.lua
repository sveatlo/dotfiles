-- more mappings are defined in `lua/config/which.lua`

local map = vim.keymap.set

default_options = { silent = true }
expr_options = { expr = true, silent = true }

--Remap space as leader key
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = ","

-- manage tabs
-- NOTE: partly using bufferline
-- TODO: simplify
-- map('', '<C-Pageup>', ':tabp<CR>')
-- map('', '<C-PageDown>', ':tabn<CR>')
map("", "<C-Pageup>", "<cmd>BufferLineCyclePrev<CR>")
map("", "<C-PageDown>", "<cmd>BufferLineCycleNext<CR>")
-- map("", "<C-A-Pageup>", ":BufferLineMovePrev<CR>")
-- map("", "<C-A-PageDown>", ":BufferLineMoveNext<CR>")
map("", "<C-A-Pageup>", "<cmd>tabmove -1<CR> <cmd>BufferLineSortByTabs<CR>")
map("", "<C-A-PageDown>", "<cmd>tabmove +1<CR> <cmd>BufferLineSortByTabs<CR>")
map("", "<C-t>", ":tabe<CR>")
map("", "<C-q>", ":tabclose<CR>")
map("", "<A-1>", "<Cmd>BufferLineGoToBuffer 1<CR>")
-- jump to tab no.
map("", "<A-2>", "<Cmd>BufferLineGoToBuffer 2<CR>")
map("", "<A-3>", "<Cmd>BufferLineGoToBuffer 3<CR>")
map("", "<A-4>", "<Cmd>BufferLineGoToBuffer 4<CR>")
map("", "<A-5>", "<Cmd>BufferLineGoToBuffer 5<CR>")
map("", "<A-6>", "<Cmd>BufferLineGoToBuffer 6<CR>")
map("", "<A-7>", "<Cmd>BufferLineGoToBuffer 7<CR>")
map("", "<A-8>", "<Cmd>BufferLineGoToBuffer 8<CR>")
map("", "<A-9>", "<Cmd>BufferLineGoToBuffer 9<CR>")

--Remap for dealing with visual line wraps
map("n", "k", "v:count == 0 ? 'gk' : 'k'", expr_options)
map("n", "j", "v:count == 0 ? 'gj' : 'j'", expr_options)

-- better indenting
map("v", "<", "<gv", default_options)
map("v", ">", ">gv", default_options)

-- paste over currently selected text without yanking it
map("v", "p", '"_dP', default_options)

-- Tab switch buffer
map("n", "<TAB>", ":bnext<CR>", default_options)
map("n", "<S-TAB>", ":bprevious<CR>", default_options)

-- Cancel search highlighting with ESC
map("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", default_options)
-- map('n', '<F4>', ':let @/ = ""<CR><F6>') -- clear search
-- map('n', '<F6>', ':<Backspace>')

-- Move selected line / block of text in visual mode
map("x", "K", ":move '<-2<CR>gv-gv", default_options)
map("x", "J", ":move '>+1<CR>gv-gv", default_options)

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
