-- configuration for the built-in lsp server

local lspconfig = require('lspconfig')
local wk = require("which-key")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities) -- nvim-cmp supports additional completion capabilities

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

    wk.register({
      g = {
        name = "go to", -- optional group name
        d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition" }, -- create a binding with label
        D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration" }, -- additional options for creating the keymap
        i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation" },
        r = { "<cmd>lua vim.lsp.buf.references()<CR>", "Go to references" },
      },
      f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Formatting" },
      ["ac"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code actions" }
    }, {
      prefix = "<leader>",
      buffer = bufnr,
    })

    wk.register({
      K = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show help" },
      ["<F2>"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    }, {
      buffer = bufnr,
    })

  end

local servers = {
    'ansiblels',
    'bashls',
    'ccls',
    'cssls',
    'eslint',
    'gopls',
    'html',
    'jedi_language_server',
    'jsonls',
    'rust_analyzer',
    'tsserver',
}
for _, lsp in pairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end


--
-- Initialize lua LS separately
--

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lspconfig.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
