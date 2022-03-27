-- configuration for vim-workspace
-- https://github.com/thaerkh/vim-workspace

vim.g.workspace_session_directory = os.getenv("HOME") .. '/.vim/sessions/' -- save sessions globally
vim.g.workspace_persist_undo_history = 1  -- persist history
vim.g.workspace_undodir = os.getenv("HOME") .. '/.vim/undodir/'
vim.g.workspace_session_disable_on_args = 1 -- disable vim sessions when opening specific file
vim.g.workspace_autosave = 0
vim.g.workspace_autosave_ignore = {'gitcommit', 'qf', 'nerdtree', 'tagbar'}

local wk = require("which-key")
wk.register({
    w = { ":ToggleWorkspace<CR>", "Toggle workspace" }
}, { prefix = "<leader>" })
