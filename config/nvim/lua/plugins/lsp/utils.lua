local utils = require("utils")

local M = {}

M.action = setmetatable({}, {
	__index = function(_, action)
		return function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { action },
					diagnostics = {},
				},
			})
		end
	end,
})

function M.setup()
	local register_capability = vim.lsp.handlers["client/registerCapability"]
	vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
		---@diagnostic disable-next-line: no-unknown
		local ret = register_capability(err, res, ctx)
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		if client then
			for buffer in pairs(client.attached_buffers) do
				vim.api.nvim_exec_autocmds("User", {
					pattern = "LspDynamicCapability",
					data = { client_id = client.id, buffer = buffer },
				})
			end
		end
		return ret
	end
	M.on_attach(M._check_methods)
	M.on_dynamic_capability(M._check_methods)
end

function M.get_clients(opts)
	local ret = {} ---@type vim.lsp.Client[]
	if vim.lsp.get_clients then
		ret = vim.lsp.get_clients(opts)
	else
		---@diagnostic disable-next-line: deprecated
		ret = vim.lsp.get_active_clients(opts)
		if opts and opts.method then
			---@param client vim.lsp.Client
			ret = vim.tbl_filter(function(client)
				return client.supports_method(opts.method, { bufnr = opts.bufnr })
			end, ret)
		end
	end
	return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

function M.capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}
	-- return require("cmp_nvim_lsp").default_capabilities(capabilities)
	return capabilities
end

function M.on_attach(on_attach, name)
	return vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf ---@type number
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client and (not name or client.name == name) then
				return on_attach(client, buffer)
			end
		end,
	})
end

function M.on_dynamic_capability(fn, opts)
	return vim.api.nvim_create_autocmd("User", {
		pattern = "LspDynamicCapability",
		group = opts and opts.group or nil,
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local buffer = args.data.buffer ---@type number
			if client then
				return fn(client, buffer)
			end
		end,
	})
end

---@type table<string, table<vim.lsp.Client, table<number, boolean>>>
M._supports_method = {}

function M.on_supports_method(method, fn)
	M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
	return vim.api.nvim_create_autocmd("User", {
		pattern = "LspSupportsMethod",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local buffer = args.data.buffer ---@type number
			if client and method == args.data.method then
				return fn(client, buffer)
			end
		end,
	})
end

function M._check_methods(client, buffer)
	-- don't trigger on invalid buffers
	if not vim.api.nvim_buf_is_valid(buffer) then
		return
	end
	-- don't trigger on non-listed buffers
	if not vim.bo[buffer].buflisted then
		return
	end
	-- don't trigger on nofile buffers
	if vim.bo[buffer].buftype == "nofile" then
		return
	end
	for method, clients in pairs(M._supports_method) do
		clients[client] = clients[client] or {}
		if not clients[client][buffer] then
			if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
				clients[client][buffer] = true
				vim.api.nvim_exec_autocmds("User", {
					pattern = "LspSupportsMethod",
					data = { client_id = client.id, buffer = buffer, method = method },
				})
			end
		end
	end
end

function M.formatter(opts)
	opts = opts or {}
	local filter = opts.filter or {}
	filter = type(filter) == "string" and { name = filter } or filter
	local ret = {
		name = "LSP",
		primary = true,
		priority = 1,
		format = function(buf)
			M.format(utils.merge({}, filter, { bufnr = buf }))
		end,
		sources = function(buf)
			local clients = M.get_clients(utils.merge({}, filter, { bufnr = buf }))
			---@param client vim.lsp.Client
			local ret = vim.tbl_filter(function(client)
				return client.supports_method("textDocument/formatting")
					or client.supports_method("textDocument/rangeFormatting")
			end, clients)
			---@param client vim.lsp.Client
			return vim.tbl_map(function(client)
				return client.name
			end, ret)
		end,
	}
	return utils.merge(ret, opts) --[[@as LazyFormatter]]
end

function M.format(opts)
	opts = vim.tbl_deep_extend(
		"force",
		{},
		opts or {},
		utils.opts("nvim-lspconfig").format or {},
		utils.opts("conform.nvim").format or {}
	)
	local ok, conform = pcall(require, "conform")
	-- use conform for formatting with LSP when available,
	-- since it has better format diffing
	if ok then
		opts.formatters = {}
		conform.format(opts)
	else
		vim.lsp.buf.format(opts)
	end
end

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
	pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
	local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
	opts = opts or {}
	opts.warn = opts.warn == nil and true or opts.warn
	path = path or ""
	local ret = root .. "/packages/" .. pkg .. "/" .. path
	if opts.warn and not vim.loop.fs_stat(ret) and not require("lazy.core.config").headless() then
		vim.notify(
			("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(
				pkg,
				path
			),
			vim.log.levels.WARN
		)
	end
	return ret
end

return M
