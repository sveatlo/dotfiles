return {
    {
        "folke/styler.nvim",
        enabled = false,
        event = "VeryLazy",
        config = function()
            require("styler").setup {
                themes = {},
            }
        end,
    },
    {
        "folke/tokyonight.nvim",
        enabled = true,
        lazy = false,
        opts = {
            style = "storm",
            transparent = false,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        },
        config = function(_, opts)
            local tokyonight = require "tokyonight"
            tokyonight.setup(opts)
        end,
    },
    {
        "catppuccin/nvim",
        enabled = true,
        lazy = true,
        name = "catppuccin",
        opts = {
            integrations = {
                alpha = true,
                cmp = true,
                gitsigns = true,
                illuminate = true,
                indent_blankline = { enabled = true },
                lsp_trouble = true,
                mason = true,
                mini = true,
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
                navic = { enabled = true, custom_bg = "lualine" },
                neotest = true,
                noice = true,
                notify = true,
                neotree = true,
                semantic_tokens = true,
                telescope = true,
                treesitter = true,
                which_key = true,
            },
        },
    },
    {
        "rebelot/kanagawa.nvim",
        enabled = false,
        lazy = false,
        name = "kanagawa"
    },
    {
        "ellisonleao/gruvbox.nvim",
        enabled = true,
        lazy = false,
        config = function()
            require("gruvbox").setup()
        end,
    },
    {
        "Shatur/neovim-ayu",
        name = "ayu",
        lazy = false,
        priority = 1000,
        config = function()
            local colors = require("ayu.colors")
            colors.generate(true)

            require("ayu").setup({
                mirage = true, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
                overrides = {
                    LspInlayHint = { fg = colors.comment },
                }, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
            })

            vim.cmd([[colorscheme ayu-mirage]])
        end,
    }
}
