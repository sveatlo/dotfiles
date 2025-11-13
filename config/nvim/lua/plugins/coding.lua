local utils = require("utils")

return {
	-- auto pairs
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = true, terminal = false },
			-- skip autopair when next character is one of these
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			-- skip autopair when the cursor is inside these treesitter nodes
			skip_ts = { "string" },
			-- skip autopair when next character is closing pair
			-- and there are more closing pairs than opening pairs
			skip_unbalanced = true,
			-- better deal with markdown code blocks
			markdown = true,
		},
	},

	-- comments
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Better text-objects
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
			if require("utils").has("which-key.nvim") then
				local which_key = require("which-key")

				-- Base definitions
				local base_mappings = {
					[" "] = "Whitespace",
					['"'] = 'Balanced "',
					["'"] = "Balanced '",
					["`"] = "Balanced `",
					["("] = "Balanced (",
					[")"] = "Balanced ) including white-space",
					[">"] = "Balanced > including white-space",
					["<lt>"] = "Balanced <",
					["]"] = "Balanced ] including white-space",
					["["] = "Balanced [",
					["}"] = "Balanced } including white-space",
					["{"] = "Balanced {",
					["?"] = "User Prompt",
					["_"] = "Underscore",
					["a"] = "Argument",
					["b"] = "Balanced ), ], }",
					["c"] = "Class",
					["f"] = "Function",
					["o"] = "Block, conditional, loop",
					["q"] = "Quote `, \", '",
					["t"] = "Tag",
				}

				-- Helper to build mappings
				local function build_mappings(prefix, entries, strip_ws)
					local result = {}
					for key, desc in pairs(entries) do
						if strip_ws then
							desc = desc:gsub(" including.*", "")
						end
						table.insert(result, {
							mode = { "o", "x" },
							[1] = prefix .. key,
							desc = desc,
						})
					end
					return result
				end

				-- Main a/i mappings
				local mappings =
					vim.list_extend(build_mappings("i", base_mappings, false), build_mappings("a", base_mappings, true))

				-- n/l (next/last) extended mappings
				for key, label in pairs({ n = "Next", l = "Last" }) do
					for k, v in pairs(base_mappings) do
						local suffix = k
						local i_key = "i" .. key .. suffix
						local a_key = "a" .. key .. suffix

						table.insert(mappings, {
							mode = { "o", "x" },
							[1] = i_key,
							desc = "Inside " .. label .. " " .. v:gsub(" including.*", ""),
						})
						table.insert(mappings, {
							mode = { "o", "x" },
							[1] = a_key,
							desc = "Around " .. label .. " " .. v:gsub(" including.*", ""),
						})
					end
				end

				-- Register with which-key
				which_key.add(mappings)
			end
		end,
	},

	{
		"danymat/neogen",
		dependencies = utils.has("mini.snippets") and { "mini.snippets" } or {},
		cmd = "Neogen",
		keys = {
			{
				"<leader>cn",
				function()
					require("neogen").generate()
				end,
				desc = "Generate Annotations (Neogen)",
			},
		},
		opts = function(_, opts)
			if opts.snippet_engine ~= nil then
				return
			end

			local map = {
				["LuaSnip"] = "luasnip",
				["mini.snippets"] = "mini",
				["nvim-snippy"] = "snippy",
				["vim-vsnip"] = "vsnip",
			}

			for plugin, engine in pairs(map) do
				if utils.has(plugin) then
					opts.snippet_engine = engine
					return
				end
			end

			if vim.snippet then
				opts.snippet_engine = "nvim"
			end
		end,
	},
}
