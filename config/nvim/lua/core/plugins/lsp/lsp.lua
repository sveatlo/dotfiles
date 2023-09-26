local nvim_lsp = require("lspconfig")
local lsp_utils = require("core.plugins.lsp.utils")
local languages = require("core.plugins.lsp.languages")

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- enable autoclompletion via nvim-cmp
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = {
	"ansiblels",
	"bashls",
	"ccls",
	"cssls",
	"dockerls",
	"gopls",
	"html",
	"jsonls",
	"pyright",
	"rust_analyzer", -- NOTE: rust_analyzer is set up automatically by rust-tools.nvim
	"lua_ls",
	"sqlls",
	"texlab",
	"tsserver",
	"yamlls",
}

for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = function(client, bufnr)
			lsp_utils.custom_lsp_attach(client, bufnr)
		end,
		before_init = function(_, config)
			if lsp == "pyright" then
				config.settings.python.pythonPath = lsp_utils.get_python_path(config.root_dir)
			end
		end,
		capabilities = capabilities,
		flags = { debounce_text_changes = 150 },
		settings = {
			json = languages.json,
			Lua = languages.lua,
			texlab = languages.tex,
			yaml = languages.yaml,
			gopls = languages.go,
			["rust-analyzer"] = languages.rust,
		},
	})
end

--  ╭────────────────────────────────────────────────────────────────────╮
--  │ Set borders on popup windows                                       │
--  ╰────────────────────────────────────────────────────────────────────╯

local border = {
	{ "🭽", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "🭾", "FloatBorder" },
	{ "▕", "FloatBorder" },
	{ "🭿", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "🭼", "FloatBorder" },
	{ "▏", "FloatBorder" },
}

-- To instead override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
