-- configure fzf-lua plugin
-- https://github.com/ibhagwan/fzf-lua

local fzf = require('fzf-lua')
local fzf_actions = require('fzf-lua.actions')

fzf.setup({})

vim.api.nvim_set_keymap('n', '<c-P>', "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>b?', "<cmd>lua require('fzf-lua').buffers()<CR>", { noremap = true, silent = true })
