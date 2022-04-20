local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ","

-- move around splits
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- manage tabs
map('', '<leader>tn', ':tabn<CR>')
map('', '<leader>tp', ':tabp<CR>')
map('', '<leader>te', ':tabe<CR>')
map('', '<leader>tc', ':tabclose<CR>')
map('', '<C-A-Pageup>', ':tabmove -1<CR>')
map('', '<C-A-PageDown>', ':tabmove +1<CR>')
map('', '<C-Pageup>', ':tabp<CR>')
map('', '<C-PageDown>', ':tabn<CR>')
map('', '<C-t>', ':tabe<CR>')
map('', '<C-q>', ':tabclose<CR>')

-- manage buffers
map('', '<Leader>sv', '<C-w>v<CR>')
map('', '<Leader>sh', '<C-w>s<CR>')
map('', '<Leader>bc', ':bdelete<CR>')
map('n', '<Leader>bn', ':bnext<CR>')
map('n', '<Leader>bp', ':bprev<CR>')
map('n', '<Leader>bf', ':bfirst<CR>')
map('n', '<Leader>bl', ':blast<CR>')


-- misc
map('n', '<F4>', ':let @/ = ""<CR><F6>') -- clear search
map('n', '<F6>', ':<Backspace>')
map('v', '<C-r>', '"hy:%s/<C-r>h//gc<left><left><left>') -- replace highlighted word
--remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Ctrl+C & Ctrl+V
-- map('v', '<C-c>', 'y')
-- map('n', '<C-v>', 'p')
-- map('i', '<C-v>', '<Esc><C-v>a')
vim.cmd [[
vmap <C-c> y: call system("wl-copy", getreg("\""))<CR>
nmap <C-v> :call setreg("\"",system("wl-paste"))<CR>p
imap <C-v> <Esc><C-v>a
]]
