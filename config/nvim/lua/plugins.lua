vim.cmd [[packadd packer.nvim]]

-- automatically compile loader file when this file changes
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])

-- startup packer - plugin manager
require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- visual
    use 'Shatur/neovim-ayu'
    use 'nvim-lualine/lualine.nvim'
    use 'kyazdani42/nvim-web-devicons'

    -- code / editing
    use 'neovim/nvim-lspconfig'
    use 'windwp/nvim-autopairs'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-textobjects' -- additional objects for treesitter
    use 'numToStr/Comment.nvim' -- easy comments
    use 'junegunn/vim-easy-align' -- aligning text
    use 'liuchengxu/vista.vim' -- tag viewer
    use { -- completion plugin
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp'
    }
    use {
        'SirVer/ultisnips',
        'quangnguyen30192/cmp-nvim-ultisnips'
    }

    -- git
    use 'tpope/vim-fugitive'
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

    -- helpers
    use 'ibhagwan/fzf-lua'
    use 'mhinz/vim-startify'
    use 'karb94/neoscroll.nvim' -- smooth scroll
    use 'tpope/vim-abolish' -- super-smart search and replace
    use {
        'kyazdani42/nvim-tree.lua',
    }
end)

-- load plugins
require('plugins/lualine')
require('plugins/treesitter')
require('plugins/lsp')
require('plugins/cmp')
require('plugins/comment')
require('plugins/nvim-autopairs')
require('plugins/neoscroll')
require('plugins/fzf')
require('plugins/tree')
require('plugins/align')
