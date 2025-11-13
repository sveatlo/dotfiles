local utils = require("utils")
local lsp_utils = require("plugins.lsp.utils")

return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "FzfLua",
		keys = {
			{ "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
			{ "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
			{
				"<leader>,",
				"<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Switch Buffer",
			},
			{ "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
			{ "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
			-- find
			{ "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
			{ "<c-p>", "<cmd>FzfLua files<cr>", desc = "Find Files" },
			{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
			{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
			-- git
			{ "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
			{ "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
			-- search
			{ '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
			{ "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
			{ "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
			{ "<leader>st", "<cmd>FzfLua live_grep<cr>", desc = "Text" },
			{ "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
			{ "<leader>sN", "<cmd>FzfLua changes<cr>", desc = "Changelist" },
			{ "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
			{ "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
			{ "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
			{ "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
			{
				"<leader>ss",
				function()
					require("fzf-lua").lsp_document_symbols({
						regex_filter = symbols_filter,
					})
				end,
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				function()
					require("fzf-lua").lsp_live_workspace_symbols({
						regex_filter = symbols_filter,
					})
				end,
				desc = "Goto Symbol (Workspace)",
			},
		},
		init = function()
			local utils = require("utils")
			utils.on_very_lazy(function()
				local opts = utils.opts("fzf-lua") or {}
				local fzf = require("fzf-lua")
				fzf.register_ui_select(opts.ui_select or nil)
			end)
		end,
		opts = {
			winopts = {
				height = 0.75,
				width = 0.80,
				row = 0.5,
				preview = {
					vertical = "down:45%",
					horizontal = "right:45%",
				},
			},
			ui_select = function(fzf_opts, items)
				return vim.tbl_deep_extend("force", fzf_opts, {
					prompt = " ",
					winopts = {
						title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
						title_pos = "center",
					},
				}, fzf_opts.kind == "codeaction" and {
					winopts = {
						layout = "vertical",
						-- height is number of items minus 15 lines for the preview, with a max of 75% screen height
						height = math.floor(math.min(vim.o.lines * 0.75 - 16, #items + 2) + 0.5) + 16,
						width = 0.5,
						preview = not vim.tbl_isempty(lsp_utils.get_clients({ bufnr = 0, name = "vtsls" })) and {
							layout = "vertical",
							vertical = "down:15,border-top",
							hidden = "hidden",
						} or {
							layout = "vertical",
							vertical = "down:15,border-top",
						},
					},
				} or {
					winopts = {
						width = 0.5,
						-- height is number of items, with a max of 80% screen height
						height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
					},
				})
			end,
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = function()
			local Keys = require("plugins.lsp.keymaps").get()
            -- stylua: ignore
            vim.list_extend(Keys, {
                { "gd", "<cmd>FzfLua lsp_definitions     jump1=true ignore_current_line=true<cr>", desc = "Goto Definition", has = "definition" },
                { "gd", "<cmd>FzfLua lsp_definitions     jump1=true ignore_current_line=true<cr>", desc = "Goto Definition", has = "definition" },
                { "gr", "<cmd>FzfLua lsp_references      jump1=true ignore_current_line=true<cr>", desc = "References", nowait = true },
                { "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", desc = "Goto Implementation" },
                { "gy", "<cmd>FzfLua lsp_typedefs        jump1=true ignore_current_line=true<cr>", desc = "Goto T[y]pe Definition" },
            })
		end,
	},
}
