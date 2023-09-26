local opts = {
	cargo = {
		allFeatures = true,
		loadOutDirsFromCheck = true,
	},
	checkOnSave = {
		enable = true,
		command = "clippy",
	},
	diagnostics = {
		enable = true,
		disabled = { "unresolved-proc-macro" },
		enableExperimental = true,
	},
	procMacro = {
		enable = true,
	},
}

return opts
