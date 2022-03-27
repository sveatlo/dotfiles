-- extra configuration for rust-specific files

vim.cmd [[autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}]]
