require("project_nvim").setup({
    patterns = {
        "Cargo.toml",
        "go.mod",
        "package.json",
        ".terraform",
        "requirements.yml",
        "pyrightconfig.json",
        "pyproject.toml",
        ".git",
    },
    -- detection_methods = { "lsp", "pattern" },
    detection_methods = { "pattern" },
})
