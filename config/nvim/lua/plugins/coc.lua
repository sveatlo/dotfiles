vim.cmd [[
    source $HOME/.config/nvim/lua/plugins/coc.vim
]]
local wk = require("which-key")

vim.g.coc_global_extensions = { 'coc-ultisnips', 'coc-pairs', 'coc-prettier' }

-- leader-leading bindings
wk.register({
    g = {
        name = "Go to",
        d = { "<Plug>(coc-definition)", "Go to definition" },
        y = { "<Plug>(coc-type-definition)", "Go to type definition" },
        i = { "<Plug>(coc-implementation)", "Go to implementation" },
        r = { "<Plug>(coc-references)", "Go to references" },
    },
    c = {
        name = "Code actions",
        r = { "<Plug>(coc-refactor)", "Refactor" },
        a = { "<Plug>(coc-codeaction)", "Show code actions"},
        f = { "<Plug>(coc-fix-current)", "Autofix problem on current line" },
    },
    f = { "<Plug>(coc-format)", "Format"},
    o = { ":CocList outline<CR>", "Show outline"}
}, {
    prefix = "<leader>",
})

-- bindings without leader
wk.register({
    ["<F2>"] = { "<Plug>(coc-rename)", "Rename"},
    -- K = { ":call <SID>show_documentation()<CR>", "Show documentation" },
    -- K = { ":call CocAction('doHover')<CR>", "Show documentation" },
    ["[d"] = { "<Plug>(coc-diagnostic-prev)", "Previous diagnostic" },
    ["]d"] = { "<Plug>(coc-diagnostic-next)", "Next diagnostic" },
}, { })

-- visual bindings
wk.register({
    ["if"] = { "<Plug>(coc-funcobj-i)", "Inside function" },
    ["af"] = { "<Plug>(coc-funcobj-a)", "Around function" },
    ["ic"] = { "<Plug>(coc-funcobj-i)", "Inside class" },
    ["ac"] = { "<Plug>(coc-funcobj-a)", "Around class" },
}, {
    mode = 'x'
})
wk.register({
    ["if"] = { "<Plug>(coc-funcobj-i)", "Inside function" },
    ["af"] = { "<Plug>(coc-funcobj-a)", "Around function" },
    ["ic"] = { "<Plug>(coc-funcobj-i)", "Inside class" },
    ["ac"] = { "<Plug>(coc-funcobj-a)", "Around class" },
}, {
    mode = 'o'
})

-- insert bindings
wk.register({
    ["<c-space>"] = { function() vim.call("coc#refresh()") end, "Trigger completion" },
}, {
    mode = 'i'
})

vim.cmd [[
    " Remap <C-f> and <C-b> for scroll float windows/popups.
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
]]

vim.cmd [[
    autocmd CursorHold * silent call CocActionAsync('highlight')
]]
