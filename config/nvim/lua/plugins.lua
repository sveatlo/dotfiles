vim.cmd [[packadd packer.nvim]]

-- startup packer - plugin manager
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- visual
    use 'navarasu/onedark.nvim'
    use 'nvim-lualine/lualine.nvim'
    use 'kyazdani42/nvim-web-devicons'

    -- code / editing
    use 'sheerun/vim-polyglot'
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/lsp_extensions.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-textobjects' -- additional objects for treesitter
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
    use 'folke/trouble.nvim' -- list of diagnostics, quickfix, ...
    use 'gpanders/editorconfig.nvim'
    use 'windwp/nvim-autopairs'
    use 'scrooloose/nerdcommenter' -- easy comments
    use 'junegunn/vim-easy-align' -- aligning text
    use 'liuchengxu/vista.vim' -- tag viewer
    use 'kosayoda/nvim-lightbulb'

    -- git
    use 'tpope/vim-fugitive'
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

    -- helpers
    use 'ibhagwan/fzf-lua'
    use 'folke/which-key.nvim' -- which key?
    use 'mhinz/vim-startify'
    use 'thaerkh/vim-workspace'
    use 'karb94/neoscroll.nvim' -- smooth scroll
    use 'tpope/vim-abolish' -- super-smart search and replace
    use {
        'kyazdani42/nvim-tree.lua',
    }
end)

-- automatically compile loader file when this file changes
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])


-- load plugins
require('plugins/whichkey')
require('plugins/lualine')
require('plugins/treesitter')
require('plugins/lsp')
require('plugins/trouble')
require('plugins/cmp')
require('plugins/lightbulb')
require('plugins/comment')
require('plugins/nvim-autopairs')
require('plugins/neoscroll')
require('plugins/fzf')
require('plugins/tree')
require('plugins/align')
require('plugins/workspace')
