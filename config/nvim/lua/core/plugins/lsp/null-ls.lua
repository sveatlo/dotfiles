local nls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

nls.setup({
	sources = {
		-- ╭─────────────╮
		-- │ Diagnostics │
		-- ╰─────────────╯
		nls.builtins.diagnostics.buf,

		-- ╭────────────╮
		-- │ Formatting │
		-- ╰────────────╯
		nls.builtins.formatting.rustfmt.with({
			extra_args = function(params)
				local Path = require("plenary.path")
				local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

				if cargo_toml:exists() and cargo_toml:is_file() then
					for _, line in ipairs(cargo_toml:readlines()) do
						local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
						if edition then
							return { "--edition=" .. edition }
						end
					end
				end
				-- default edition when we don't find `Cargo.toml` or the `edition` in it.
				return { "--edition=2021" }
			end,
		}),
		nls.builtins.formatting.goimports,
		nls.builtins.formatting.gofumpt,
		nls.builtins.formatting.stylua,
		nls.builtins.formatting.shfmt,
		nls.builtins.formatting.black, -- python
		nls.builtins.formatting.prettier.with({
			extra_args = { "--single-quote", "false" },
		}),
		nls.builtins.formatting.buf,
		nls.builtins.formatting.protolint,
		nls.builtins.formatting.latexindent.with({
			extra_args = { "-g", "/dev/null" }, -- https://github.com/cmhughes/latexindent.pl/releases/tag/V3.9.3
		}),

		--  ╭──────────────╮
		--  │ Code actions │
		--  ╰──────────────╯
		nls.builtins.code_actions.gomodifytags,
		nls.builtins.code_actions.refactoring,
		nls.builtins.code_actions.gitsigns,

		-- ╭───────╮
		-- │ Hover │
		-- ╰───────╯
		nls.builtins.hover.dictionary,
	},
	on_attach = function(client, bufnr)
		local wk = require("which-key")
		local default_options = { silent = true }

		wk.register({
			l = {
				F = { "<cmd>lua require('core.plugins.lsp.utils').toggle_autoformat()<cr>", "Toggle format on save" },
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
