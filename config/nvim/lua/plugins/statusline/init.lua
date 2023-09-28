return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "meuter/lualine-so-fancy.nvim",
        },
        event = "VeryLazy",
        opts = function()
            local components = require("plugins.statusline.components")
            return {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = {},
                    section_separators = {},
                    disabled_filetypes = {
                        statusline = { "alpha", "lazy", "fugitive", "" },
                        winbar = {
                            "help",
                            "alpha",
                            "lazy",
                        },
                    },
                    always_divide_middle = true,
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { { "fancy_mode", width = 6 } },
                    lualine_b = { components.git_repo, "branch" },
                    lualine_c = {
                        { "fancy_cwd",        substitute_home = true },
                        -- "filename",
                        components.diff,
                        { "fancy_diagnostics" },
                        components.noice_command,
                        components.noice_mode,
                        -- { require("NeoComposer.ui").status_recording },
                        components.separator,
                        { "fancy_lsp_servers" },
                    },
                    lualine_x = { components.spaces, "encoding", "fileformat", "filetype", "progress" },
                    lualine_y = {},
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                extensions = { "nvim-tree", "toggleterm", "quickfix" },
            }
        end,
    },
}