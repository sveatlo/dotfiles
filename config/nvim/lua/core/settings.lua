--
-- Main configuration and general options
--

-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local cmd = vim.cmd                         -- Execute Vim commands
local exec = vim.api.nvim_exec              -- Execute Vimscript
-- local g = vim.g                             -- Global variables
local opt = vim.opt                         -- Set options (global/buffer/windows-scoped)
-- local fn = vim.fn                           -- Call Vim functions

-- general
opt.encoding = "utf-8"
opt.backspace = "eol,start,indent"          -- allow backspacing over indent, eol, and start
opt.mouse = "nvch"
opt.cmdheight = 1
opt.autoread = true
opt.hidden = true                           -- enable hidden buffers
opt.history = 1000
opt.completeopt = "menu,menuone,noselect"
opt.undofile = true                         -- save history undo file
opt.updatetime = 250
opt.whichwrap = "b,s,<,>,[,]"
opt.clipboard:append("unnamedplus")
opt.shortmess:append("c")
opt.sessionoptions:remove("blank")

-- search
opt.hlsearch = true                         -- highlight on search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- numbering
opt.number = true
opt.relativenumber = true

-- indentation
opt.cindent = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.list = true
opt.listchars = "tab:»·,trail:·"

-- ui
opt.titlestring = "%f title"                -- display filename in terminal window
opt.signcolumn = 'number'

-- Remove whitespace on save
cmd [[autocmd BufWritePre * :%s/\s\+$//e]]

-- Don't auto commenting new lines
cmd [[autocmd BufEnter * set fo-=c fo-=r fo-=o]]
