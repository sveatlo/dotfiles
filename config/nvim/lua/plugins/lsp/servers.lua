local M = {}

local lsp_utils = require("plugins.lsp.utils")
local icons = require("config.icons")

local function lsp_init()
	local config = {
		-- options for vim.diagnostic.config()
		---@type vim.diagnostic.Opts
		diagnostics = {
			underline = true,
			update_in_insert = false,
			virtual_text = {
				spacing = 4,
				source = "if_many",
				prefix = "●",
				-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
				-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
				-- prefix = "icons",
			},
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
					[vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
					[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
					[vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
				},
			},
		},
		-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
		-- Be aware that you also will need to properly configure your LSP server to
		-- provide the inlay hints.
		inlay_hints = {
			enabled = true,
			exclude = {}, -- filetypes for which you don't want to enable inlay hints
		},
		-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
		-- Be aware that you also will need to properly configure your LSP server to
		-- provide the code lenses.
		codelens = {
			enabled = false,
		},
		-- add any global capabilities here
		capabilities = {
			workspace = {
				fileOperations = {
					didRename = true,
					willRename = true,
				},
			},
		},
		-- options for vim.lsp.buf.format
		-- `bufnr` and `filter` is handled by the LazyVim formatter,
		-- but can be also overridden when specified
		format = {
			formatting_options = nil,
			timeout_ms = nil,
		},
		servers = {
			lua_ls = {
				-- mason = false, -- set to false if you don't want this server to be installed with mason
				-- Use this to add any additional keymaps
				-- for specific lsp servers
				-- ---@type LazyKeysSpec[]
				-- keys = {},
				settings = {
					Lua = {
						workspace = {
							checkThirdParty = false,
						},
						codeLens = {
							enable = true,
						},
						completion = {
							callSnippet = "Replace",
						},
						doc = {
							privateName = { "^_" },
						},
						hint = {
							enable = true,
							setType = false,
							paramType = true,
							paramName = "Disable",
							semicolon = "Disable",
							arrayIndex = "Disable",
						},
					},
				},
			},
		},
		setup = {
			-- example to setup with typescript.nvim
			-- tsserver = function(_, opts)
			--   require("typescript").setup({ server = opts })
			--   return true
			-- end,
			-- Specify * to use this function as a fallback for any server
			-- ["*"] = function(server, opts) end,
		},
	}

	-- Diagnostic configuration
	vim.diagnostic.config(config.diagnostic)

	-- Hover configuration
	-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)

	-- Signature help configuration
	-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end

function M.setup(_, opts)
	lsp_utils.on_attach(function(client, bufnr)
		require("plugins.lsp.format").on_attach(client, bufnr)
		require("plugins.lsp.keymaps").on_attach(client, bufnr)

		if client.supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end

		if client.supports_method("textDocument/documentHighlight") then
			vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
			vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
			vim.api.nvim_create_autocmd("CursorHold", {
				callback = vim.lsp.buf.document_highlight,
				buffer = bufnr,
				group = "lsp_document_highlight",
				desc = "Document Highlight",
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
				callback = vim.lsp.buf.clear_references,
				buffer = bufnr,
				group = "lsp_document_highlight",
				desc = "Clear All the References",
			})
		end
	end)

	lsp_init() -- diagnostics, handlers

	local servers = opts.servers
	local capabilities = lsp_utils.capabilities()

	local function setup(server)
		local server_opts = vim.tbl_deep_extend("force", {
			capabilities = capabilities,
		}, servers[server] or {})

		if opts.setup[server] then
			if opts.setup[server](server, server_opts) then
				return
			end
		elseif opts.setup["*"] then
			if opts.setup["*"](server, server_opts) then
				return
			end
		end
		require("lspconfig")[server].setup(server_opts)
	end

	-- -- Add bun for Node.js-based servers
	-- local lspconfig_util = require("lspconfig.util")
	-- local add_bun_prefix = require("plugins.lsp.bun").add_bun_prefix
	-- lspconfig_util.on_setup = lspconfig_util.add_hook_before(lspconfig_util.on_setup, add_bun_prefix)

	-- get all the servers that are available thourgh mason-lspconfig
	local has_mason, mlsp = pcall(require, "mason-lspconfig")
	local all_mslp_servers = {}
	if has_mason then
		all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
	end

	local ensure_installed = {} ---@type string[]
	for server, server_opts in pairs(servers) do
		if server_opts then
			server_opts = server_opts == true and {} or server_opts
			if server_opts.enabled then
				-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
				if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
					setup(server)
				else
					ensure_installed[#ensure_installed + 1] = server
				end
			end
		end
	end

	if has_mason then
		mlsp.setup({ ensure_installed = ensure_installed })
		mlsp.setup_handlers({ setup })
	end
end

return M
