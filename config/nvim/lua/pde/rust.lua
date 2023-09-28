if not require("config").pde.rust then
	return {}
end

local function get_codelldb()
	local mason_registry = require("mason-registry")
	local codelldb = mason_registry.get_package("codelldb")
	local extension_path = codelldb:get_install_path() .. "/extension/"
	local codelldb_path = extension_path .. "adapter/codelldb"
	local liblldb_path = ""
	if vim.loop.os_uname().sysname:find("Windows") then
		liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
	elseif vim.fn.has("mac") == 1 then
		liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
	else
		liblldb_path = extension_path .. "lldb/lib/liblldb.so"
	end
	return codelldb_path, liblldb_path
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "codelldb" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		ft = "rust",
		dependencies = { "simrat39/rust-tools.nvim", "rust-lang/rust.vim" },
		opts = {
			servers = {
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
							},
							checkOnSave = {
								enable = true,
								command = "clippy",
							},
							diagnostics = {
								enable = true,
								disabled = { "unresolved-proc-macro" },
								enableExperimental = true,
							},
							procMacro = {
								enable = true,
								ignored = {
									["async-trait"] = { "async_trait" },
									["napi-derive"] = { "napi" },
									["async-recursion"] = { "async_recursion" },
								},
							},
						},
					},
				},
				-- taplo = {},
			},
			setup = {
				rust_analyzer = function(_, opts)
					local codelldb_path, liblldb_path = get_codelldb()
					local lsp_utils = require("plugins.lsp.utils")
					lsp_utils.on_attach(function(client, bufnr)
						local map = function(mode, lhs, rhs, desc)
							if desc then
								desc = desc
							end
							vim.keymap.set(
								mode,
								lhs,
								rhs,
								{ silent = true, desc = desc, buffer = bufnr, noremap = true }
							)
						end

						if client.name == "rust_analyzer" then
							map("n", "<leader>le", "<cmd>RustRunnables<cr>", "Runnables")
							map("n", "<leader>lE", "<cmd>RustDebuggables<cr>", "Debuggables")
                            -- stylua: ignore
                            map("n", "<leader>ll", function() vim.lsp.codelens.run() end, "Code Lens")
							map("n", "<leader>lt", "<cmd>Cargo test<cr>", "Cargo test")
							map("n", "<leader>lR", "<cmd>Cargo run<cr>", "Cargo run")
						end
					end)

					vim.api.nvim_create_autocmd({ "BufEnter" }, {
						pattern = { "Cargo.toml" },
						callback = function(event)
							local bufnr = event.buf

							local map = function(mode, lhs, rhs, desc)
								if desc then
									desc = desc
								end
								vim.keymap.set(
									mode,
									lhs,
									rhs,
									{ silent = true, desc = desc, buffer = bufnr, noremap = true }
								)
							end
							map("n", "<leader>lc", function() end, "+Crates")
							map("n", "<leader>lcy", "<cmd>lua require'crates'.open_repository()<cr>", "Open Repository")
							map("n", "<leader>lcp", "<cmd>lua require'crates'.show_popup()<cr>", "Show Popup")
							map("n", "<leader>lci", "<cmd>lua require'crates'.show_crate_popup()<cr>", "Show Info")
							map(
								"n",
								"<leader>lcf",
								"<cmd>lua require'crates'.show_features_popup()<cr>",
								"Show Features"
							)
							map(
								"n",
								"<leader>lcd",
								"<cmd>lua require'crates'.show_dependencies_popup()<cr>",
								"Show Dependencies"
							)
						end,
					})

					require("rust-tools").setup({
						tools = { -- rust-tools options
							executor = require("rust-tools.executors").termopen,
							on_initialized = function()
								vim.cmd([[
                                  augroup RustLSP
                                    autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                                    autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                                    autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                                  augroup END
                                ]])
							end,
							reload_workspace_from_cargo_toml = true,
							inlay_hints = {
								auto = false,
							},
							hover_actions = {
								border = {
									{ "🭽", "FloatBorder" },
									{ "▔", "FloatBorder" },
									{ "🭾", "FloatBorder" },
									{ "▕", "FloatBorder" },
									{ "🭿", "FloatBorder" },
									{ "▁", "FloatBorder" },
									{ "🭼", "FloatBorder" },
									{ "▏", "FloatBorder" },
								},
								max_width = nil,
								max_height = nil,
								auto_focus = false,
							},
						},
						server = opts,
						dap = {
							adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
						},
					})
					return true
				end,
			},
		},
	},
	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			null_ls = {
				enabled = true,
				name = "crates.nvim",
			},
			popup = {
				border = "rounded",
			},
			src = {
				cmp = {
					enabled = true,
				},
			},
		},
		config = function(_, opts)
			require("crates").setup(opts)
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"Saecki/crates.nvim",
				event = { "BufRead Cargo.toml" },
			},
		},
		opts = function(_, opts)
			local cmp = require("cmp")
			-- opts.sources = cmp.config.sources(vim.list_extend(opts.sources or {}, {
			--     { name = "crates" },
			-- }))
			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
				pattern = "Cargo.toml",
				callback = function()
					cmp.setup.buffer({ sources = { { name = "crates" } } })
				end,
			})
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			table.insert(
				opts.sources,
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
				})
			)
		end,
	},
	{
		"mfussenegger/nvim-dap",
		opts = {
			setup = {
				codelldb = function()
					local codelldb_path, _ = get_codelldb()
					local dap = require("dap")
					dap.adapters.codelldb = {
						type = "server",
						port = "${port}",
						executable = {
							command = codelldb_path,
							args = { "--port", "${port}" },

							-- On windows you may have to uncomment this:
							-- detached = false,
						},
					}
					dap.configurations.cpp = {
						{
							name = "Launch file",
							type = "codelldb",
							request = "launch",
							program = function()
								return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
							end,
							cwd = "${workspaceFolder}",
							stopOnEntry = false,
						},
					}

					dap.configurations.c = dap.configurations.cpp
					dap.configurations.rust = dap.configurations.cpp
				end,
			},
		},
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			{ "rouge8/neotest-rust", ft = "rust" },
		},
		opts = function(_, opts)
			vim.list_extend(opts.adapters, {
				require("neotest-rust"),
			})
		end,
	},
}
