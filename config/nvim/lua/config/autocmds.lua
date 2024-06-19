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
		"floggraph",
		"fugitive",
		"git",
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

-- when there is no buffer left show Alpha dashboard
-- requires "famiu/bufdelete.nvim" and "goolord/alpha-nvim"
local alpha_on_empty = api.nvim_create_augroup("alpha_on_empty", { clear = true })
api.nvim_create_autocmd("User", {
	pattern = "BDeletePost*",
	group = alpha_on_empty,
	callback = function(event)
		local fallback_name = vim.api.nvim_buf_get_name(event.buf)
		local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
		local fallback_on_empty = fallback_name == "" and fallback_ft == ""

		if fallback_on_empty then
			-- require("neo-tree").close_all()
			vim.api.nvim_command("Alpha")
			vim.api.nvim_command(event.buf .. "bwipeout")
		end
	end,
})

-- Enable spell checking for certain file types
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.txt", "*.md", "*.tex" },
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = "en"
	end,
})
