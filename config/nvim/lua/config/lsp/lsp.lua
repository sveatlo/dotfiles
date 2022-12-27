local nvim_lsp = require("lspconfig")
local utils = require("config.lsp.utils")
local languages = require("config.lsp.languages")

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- enable autoclompletion via nvim-cmp
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = {
	"ansiblels",
	"bashls",
	"ccls",
	"cssls",
	"dockerls",
	-- "eslint",
	"gopls",
	"html",
	"jedi_language_server",
	"jsonls",
	"pyright",
	"rust_analyzer",
	"sumneko_lua",
	"sqls",
	"texlab",
	"tsserver",
	"yamlls",
}

for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = function(client, bufnr)
			utils.custom_lsp_attach(client, bufnr)
		end,
		before_init = function(_, config)
			if lsp == "pyright" then
				config.settings.python.pythonPath = utils.get_python_path(config.root_dir)
			end
		end,
		capabilities = capabilities,
		flags = { debounce_text_changes = 150 },
		settings = {
			json = languages.json,
			Lua = languages.lua,
			texlab = languages.tex,
			yaml = languages.yaml,
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
