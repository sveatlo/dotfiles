require("Comment").setup({
    ---Add a space b/w comment and the line
    ---@type boolean|fun():boolean
    padding = true,

    ---Whether the cursor should stay at its position
    ---NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
    ---@type boolean
    sticky = true,

    ---Lines to be ignored while comment/uncomment.
    ---Could be a regex string or a function that returns a regex string.
    ---Example: Use '^$' to ignore empty lines
    ---@type string|fun():string
    ignore = nil,

    ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
    ---NOTE: If `mappings = false` then the plugin won't create any mappings
    ---@type boolean|table
    mappings = false,
})

local wk = require("which-key")

wk.register({
    name = "Comment",
    c = { "<cmd>lua require('Comment.api').toggle.linewise(motion, cfg)<CR>", "Comment line" },
}, {
    prefix = "<leader>c",
    mode = "n",
})
wk.register({
    name = "Comment",
    c = { "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", "Comment selected" },
}, {
    prefix = "<leader>c",
    mode = "x",
})
