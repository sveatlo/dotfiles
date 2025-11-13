local api = vim.api

--- Remove all trailing whitespace on save
local TrimWhiteSpaceGrp = api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
api.nvim_create_autocmd("BufWritePre", {
	command = [[:%s/\s\+$//e]],
	group = TrimWhiteSpaceGrp,
})

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- Highlight on yank
local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
	command = "silent! lua vim.highlight.on_yank()",
	group = yankGrp,
})
-- go to last loc when opening a buffer
api.nvim_create_autocmd(
	"BufReadPost",
	{ command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)
-- windows to close with "q"
api.nvim_create_autocmd("FileType", {
	pattern = {
		"OverseerForm",
		"OverseerList",
		"TelescopePrompt",
		"checkhealth",
		"dap-float",
		"floggraph",
		"fugitive",
		"git",
		"grug-far",
		"help",
		"lspinfo",
		"man",
		"neoai-input",
		"neoai-output",
		"neotest-output",
		"neotest-summary",
		"notify",
		"qf",
		"query",
		"sagarename",
		"spectre_panel",
		"startuptime",
		"toggleterm",
		"tsplayground",
		"vim",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})
api.nvim_create_autocmd("FileType", {
	pattern = {
		"oil",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>bdelete<cr>", { buffer = event.buf, silent = true })
	end,
})
-- windows to close with <esc>
api.nvim_create_autocmd("FileType", {
	pattern = {
		"saga_codeaction",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
local autoCreateDirGrp = api.nvim_create_augroup("AutoCreateDir", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = autoCreateDirGrp,
	callback = function(event)
		-- skip for oil file type
		local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
		if filetype == "oil" then
			return
		end

		local file = vim.loop.fs_realpath(event.match) or event.match

		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- disable list option in certain filetypes
api.nvim_create_autocmd("FileType", { pattern = { "NeoGitStatus" }, command = [[setlocal list!]] })

-- show cursor line only in active window
local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	pattern = "*",
	command = "set cursorline",
	group = cursorGrp,
})
api.nvim_create_autocmd(
	{ "InsertEnter", "WinLeave" },
	{ pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- Enable spell checking for certain file types
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.txt", "*.md", "*.tex" },
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = "en"
	end,
})
