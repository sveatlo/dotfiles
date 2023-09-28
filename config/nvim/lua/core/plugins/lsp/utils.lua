M = {}

DIAGNOSTICS_ACTIVE = true -- must be global since the toggle function is called in which.lua
-- toggle diagnostics line
M.toggle_diagnostics = function()
	DIAGNOSTICS_ACTIVE = not DIAGNOSTICS_ACTIVE
	if DIAGNOSTICS_ACTIVE then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end

AUTOFORMAT_ACTIVE = true
-- toggle null-ls's autoformatting
M.toggle_autoformat = function()
	require("core.utils").notify("Toggling autoformatting", 1, "lsp.utils")
	AUTOFORMAT_ACTIVE = not AUTOFORMAT_ACTIVE
end

-- detect python venv
-- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
local util = require("lspconfig/util")
local path = util.path
function M.get_python_path(workspace)
	-- Use activated virtualenv.
	if vim.env.VIRTUAL_ENV then
		return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
	end
	-- Find and use virtualenv in workspace directory.
	for _, pattern in ipairs({ "*", ".*" }) do
		local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
		if match ~= "" then
			return path.join(path.dirname(match), "bin", "python")
		end
	end
	-- Fallback to system Python.
	return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

function M.custom_lsp_attach(client, bufnr)
	-- disable formatting for LSP clients as this is handled by null-ls
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false

	-- enable inlay hints when supported
	if client.supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint(bufnr, true)
	end

	local wk = require("which-key")
	local default_options = { buffer = bufnr, silent = true }
	wk.register({
		-- code/LSP
		K = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show help" },
		["<F2>"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
		["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Previous diagnostic error" },
		["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next diagnostic error" },
	}, {})
	wk.register({
		l = {
			name = "LSP",
			f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
			D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go To Declaration" },
			d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go To Definition" },
			t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type Definition" },
			r = { "<cmd>lua vim.lsp.buf.references()<cr>", "References" },
			I = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Show implementations" },
			k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
			K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover Commands" },
			R = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
			a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
			e = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Document Diagnostics" },
			i = { "<cmd>LspInfo<cr>", "Connected Language Servers" },
			l = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Line Diagnostics" },
			n = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
			p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
			q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix Diagnostics" },
			s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
			w = {
				name = "Workspace",
				a = {
					"<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>",
					"Add Workspace Folder",
				},
				d = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
				l = {
					"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
					"List Workspace Folders",
				},
				r = {
					"<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>",
					"Remove Workspace Folder",
				},
				s = {
					"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
					"Workspace Symbols",
				},
			},
		},
	}, { prefix = "<leader>", mode = "n", default_options })
end

return M