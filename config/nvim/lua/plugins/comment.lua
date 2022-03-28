-- configure Comment plugin
-- https://github.com/numToStr/Comment.nvim

local comment = require('Comment')

comment.setup()

vim.api.nvim_set_keymap('n', '<leader>cc', "", { noremap = true, silent = true })
