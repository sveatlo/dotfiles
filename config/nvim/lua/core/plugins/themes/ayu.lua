local colors = require("ayu.colors")
colors.generate(true)

require("ayu").setup({
	mirage = true, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
	overrides = {
		LspInlayHint = { fg = colors.comment },
	}, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
})
vim.cmd([[colorscheme ayu-mirage]])
