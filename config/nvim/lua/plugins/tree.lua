-- configuration for nvim-tree.lua
-- https://github.com/kyazdani42/nvim-tree.lua

vim.g.nvim_tree_respect_buf_cwd = 1

require("nvim-tree").setup({
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true
  },
})

local wk = require("which-key")
wk.register({
    ["<F3>"] = { ":NvimTreeToggle<CR>", "Open file tree" }, -- create a binding with label
}, {})
