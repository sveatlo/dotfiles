vim.cmd [[
    " autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
    autocmd FileType go nmap gtj :CocCommand go.tags.add json<cr>
    autocmd FileType go nmap gty :CocCommand go.tags.add yaml<cr>
    autocmd FileType go nmap gtm :CocCommand go.tags.add mapstructure<cr>
    autocmd FileType go nmap gtx :CocCommand go.tags.clear<cr>
    autocmd FileType go nmap gtg :CocCommand go.test.generate.file<cr>
]]
