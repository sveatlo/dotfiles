vim.cmd [[packadd packer.nvim]]

-- startup packer - plugin manager
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- visual
    use 'Shatur/neovim-ayu'
    use 'nvim-lualine/lualine.nvim'
    use 'kyazdani42/nvim-web-devicons'

    -- code / editing
    use 'sheerun/vim-polyglot'
    use { 'neoclide/coc.nvim', branch = 'release' }
    use 'SirVer/ultisnips'
    use 'gpanders/editorconfig.nvim'
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
require('plugins/align')
require('plugins/comment')
require('plugins/fzf')
require('plugins/lualine')
require('plugins/neoscroll')
require('plugins/tree')
require('plugins/whichkey')
require('plugins/workspace')
require('plugins/coc')
