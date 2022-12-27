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
		Copilot = "",
	},
})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
