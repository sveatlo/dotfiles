local nls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

nls.setup({
	sources = {
		nls.builtins.formatting.rustfmt,
		nls.builtins.formatting.goimports,
		nls.builtins.formatting.gofumpt,
		nls.builtins.formatting.stylua,
		nls.builtins.formatting.shfmt,
		nls.builtins.formatting.prettier.with({
			extra_args = { "--single-quote", "false" },
		}),
		nls.builtins.formatting.latexindent.with({
			extra_args = { "-g", "/dev/null" }, -- https://github.com/cmhughes/latexindent.pl/releases/tag/V3.9.3
		}),

		nls.builtins.diagnostics.vale,
		nls.builtins.diagnostics.eslint_d,

		nls.builtins.code_actions.gomodifytags,
		nls.builtins.code_actions.refactoring,
		nls.builtins.code_actions.gitsigns,
		nls.builtins.code_actions.shellcheck,
	},
	on_attach = function(client, bufnr)
		local wk = require("which-key")
		local default_options = { silent = true }

		wk.register({
			l = {
				F = { "<cmd>lua require('config.lsp.utils').toggle_autoformat()<cr>", "Toggle format on save" },
			},
		}, { prefix = "<leader>", mode = "n", default_options })

		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					if AUTOFORMAT_ACTIVE then -- global var defined in functions.lua
						vim.lsp.buf.format({ bufnr = bufnr })
					end
				end,
			})
		end
	end,
})
