local M = {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-calc",
		"lukas-reineke/cmp-rg",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		{
			"zbirenbaum/copilot-cmp",
			config = function()
				--  ╭────────────────────────────────────────────────────────────────────╮
				--  │ set up compilot cmp plugin                                         │
				--  ╰────────────────────────────────────────────────────────────────────╯
				require("copilot_cmp").setup({
					method = "getCompletionsCycling",
					formatters = {
						label = require("copilot_cmp.format").format_label_text,
						insert_text = require("copilot_cmp.format").format_insert_text,
						preview = require("copilot_cmp.format").deindent,
					},
				})

				--  ╭────────────────────────────────────────────────────────────────────╮
				--  │ set up highlighting and icon                                       │
				--  ╰────────────────────────────────────────────────────────────────────╯
				local lspkind = require("lspkind")
				lspkind.init({
					symbol_map = {
						Copilot = require("core.utils.icons").ui.Github,
					},
				})

				vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
			end,
		},
	},
	config = function()
		-- Setup nvim-cmp.
		local cmp = require("cmp")
		local lspkind = require("lspkind")
		local luasnip = require("luasnip")
		local cmp_compare = require("cmp.config.compare")

		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		cmp.setup({
			formatting = {
				format = lspkind.cmp_format({
					with_text = false,
					maxwidth = 50,
					mode = "symbol",
					menu = {
						copilot = "CP",
						buffer = "BUF",
						rg = "RG",
						nvim_lsp = "LSP",
						nvim_lsp_signature_help = "SIG",
						path = "PATH",
						luasnip = "SNIP",
						calc = "CALC",
						spell = "SPELL",
					},
				}),
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = {
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.close(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			},
			sources = {
				{ name = "copilot" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "luasnip", max_item_count = 5 },
				{ name = "buffer", keyword_length = 5, max_item_count = 5 },
				{ name = "calc" },
				-- { name = "spell", keyword_length = 5 },
				{ name = "path" },
				{ name = "rg", keyword_length = 5, max_item_count = 5 },
			},
			sorting = {
				priority_weight = 2,
				comparators = {
					require("copilot_cmp.comparators").prioritize,
					require("copilot_cmp.comparators").score,

					cmp_compare.offset,
					cmp_compare.exact,
					cmp_compare.score,
					cmp_compare.recently_used,
					cmp_compare.kind,
					cmp_compare.sort_text,
					cmp_compare.length,
					cmp_compare.order,
				},
			},
		})

		-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})
	end,
}

return M