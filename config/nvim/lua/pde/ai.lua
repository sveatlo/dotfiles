if not require("config").pde.ai then
	return {}
end

return {
	{
		"zbirenbaum/copilot.lua",
		enabled = true,
		event = "VeryLazy",
		-- cmd = "Copilot",
		build = ":Copilot auth",
		opts = {
			filetypes = {
				markdown = true,
				help = true,
			},
			suggestion = {
				enabled = false,
			},
			panel = {
				enabled = true,
				auto_refresh = true,
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		optional = true,
		event = "VeryLazy",
		opts = function(_, opts)
			local Utils = require("utils")
			local colors = {
				[""] = Utils.fg("Special"),
				["Normal"] = Utils.fg("Special"),
				["Warning"] = Utils.fg("DiagnosticError"),
				["InProgress"] = Utils.fg("DiagnosticWarn"),
			}
			table.insert(opts.sections.lualine_x, 2, {
				function()
					local icon = require("config.icons").icons.kinds.Copilot
					local status = require("copilot.api").status.data
					return icon .. (status.message or "")
				end,
				cond = function()
					local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
					return ok and #clients > 0
				end,
				color = function()
					if not package.loaded["copilot"] then
						return
					end
					local status = require("copilot.api").status.data
					return colors[status.status] or colors[""]
				end,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"zbirenbaum/copilot-cmp",
				dependencies = { "zbirenbaum/copilot.lua" },
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
				end,
			},
		},
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.sources = cmp.config.sources(vim.list_extend(opts.sources or {}, {
				{ name = "copilot", group_index = 0 },
			}))
		end,
	},
}
