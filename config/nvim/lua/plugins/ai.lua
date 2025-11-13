return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},
	{ "fang2hou/blink-copilot" },
	{
		"saghen/blink.cmp",
		optional = true,
		dependencies = { "fang2hou/blink-copilot" },
		opts = {
			sources = {
				default = { "copilot" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},
		},
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		cmd = "CopilotChat",
		opts = function()
			local user = vim.env.USER or "User"
			return {
				auto_insert_mode = true,
				question_header = "  " .. user .. " ",
				answer_header = "  Copilot ",
				window = {
					width = 0.4,
				},
				mappings = {
					reset = {
						normal = "<C-r>",
						insert = "<C-r>",
					},
				},
				model = "gpt-4.1",

				providers = {
					-- copilot = {
					-- 	get_models = function()
					-- 		return {}
					-- 	end,
					-- },
					-- github_models = {
					-- 	get_models = function()
					-- 		return {}
					-- 	end,
					-- },
					openai = {
						prepare_input = require("CopilotChat.config.providers").copilot.prepare_input,
						prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,

						get_url = function()
							return "https://api.openai.com/v1/chat/completions"
						end,

						get_headers = function()
							local api_key = assert(os.getenv("OPENAI_API_KEY"), "OPENAI_API_KEY env var not set")
							return {
								Authorization = "Bearer " .. api_key,
								["Content-Type"] = "application/json",
							}
						end,

						get_models = function(headers)
							local response, err =
								require("CopilotChat.utils").curl_get("https://api.openai.com/v1/models", {
									headers = headers,
									json_response = true,
								})
							if err then
								error(err)
							end
							return vim.iter(response.body.data)
								:filter(function(model)
									local exclude_patterns = {
										"audio",
										"babbage",
										"dall%-e",
										"davinci",
										"embedding",
										"image",
										"moderation",
										"realtime",
										"transcribe",
										"tts",
										"whisper",
									}
									for _, pattern in ipairs(exclude_patterns) do
										if model.id:match(pattern) then
											return false
										end
									end
									return true
								end)
								:map(function(model)
									return {
										id = model.id,
										name = model.id,
									}
								end)
								:totable()
						end,

						embed = function(inputs, headers)
							local response, err =
								require("CopilotChat.utils").curl_post("https://api.openai.com/v1/embeddings", {
									headers = headers,
									json_request = true,
									json_response = true,
									body = {
										model = "text-embedding-3-small",
										input = inputs,
									},
								})
							if err then
								error(err)
							end
							return response.body.data
						end,
					},
				},
			}
		end,
		keys = {
			{ "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>aa",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				function()
					return require("CopilotChat").reset()
				end,
				desc = "Clear (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>aq",
				function()
					vim.ui.input({
						prompt = "Quick Chat: ",
					}, function(input)
						if input ~= "" then
							require("CopilotChat").ask(input)
						end
					end)
				end,
				desc = "Quick Chat (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ap",
				function()
					require("CopilotChat").select_prompt()
				end,
				desc = "Prompt Actions (CopilotChat)",
				mode = { "n", "v" },
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-chat",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end,
			})

			chat.setup(opts)
		end,
	},
	{
		"folke/edgy.nvim",
		opts = function(_, opts)
			opts.right = opts.right or {}
			table.insert(opts.right, {
				ft = "copilot-chat",
				title = "Copilot Chat",
				size = { width = 50 },
			})
		end,
	},

	{
		"joelxr/pitaco.nvim",
		dependencies = {
			"j-hui/fidget.nvim",
		},
		keys = {
			{ "<leader>ar", "<cmd>Pitaco<cr>", desc = "Review code" },
		},
		opts = {
			provider = "openai",
		},
	},
}
