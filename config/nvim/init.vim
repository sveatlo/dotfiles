" Author: Svätopluk Hanzel (sveatlo)
" inspired from:
"   v0n aka Vivien Didelot
"   Michael Sanders
"   Mathieu Schroeter
"   Bart Trojanowski
"   Ben Awad (benawad)

" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
    " visual
    Plug 'ayu-theme/ayu-vim'
    "Plug 'morhetz/gruvbox'
    Plug 'ryanoasis/vim-devicons'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'junegunn/seoul256.vim'

    " code
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'scrooloose/nerdcommenter'                 " easy commenting
    Plug 'junegunn/vim-easy-align'                  " aligning text
    Plug 'alpaca-tc/beautify.vim'
    " Plug 'terryma/vim-multiple-cursors'             " multiple cursors support
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

    " git
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'

    " helpers
    Plug 'sheerun/vim-polyglot'             " multi-language pack
    Plug 'tpope/vim-abolish'                " super smart search and replace
    Plug 'mhinz/vim-startify'               " startup screen
    Plug 'thaerkh/vim-workspace'            " ultimate session management
    Plug 'editorconfig/editorconfig-vim'    " vim support for editorconfig
    Plug 'preservim/nerdtree'               " file browser
    Plug 'Xuyuanp/nerdtree-git-plugin'      " show git file status in nerdtree
    Plug 'psliwka/vim-smoothie'             " smooth scrolling
    Plug 'Yggdroot/indentLine'              " show indentation level
    " Plug 'ctrlpvim/ctrlp.vim'               " fuzzy find files

    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

" Initialize plugin system
call plug#end()


" Theming
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set termguicolors
let ayucolor="mirage"
colorscheme ayu
" airline statusline
let g:airline_powerline_fonts = 1
let g:airline_theme = "ayu"
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" General options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=","
" set autochdir
set autoread
set backspace=eol,start,indent " allow backspacing over indent, eol, & start
set cindent
set cmdheight=2
set enc=utf-8
set guitablabel=\[%N\]\ %t\ %M
set hidden
set history=1000
set hlsearch
set ignorecase smartcase " use \c or \C to change case-sensitivity
set incsearch
set mouse=nvch
set nobackup
set nowritebackup
set number relativenumber
set sessionoptions-=blank
set shortmess+=c
set signcolumn=yes
set titlestring=%f title " Display filename in terminal window
set undolevels=100
set updatetime=300
set whichwrap=b,s,<,>,[,]  " Allow tranversing to prev/next line from beginning/end of line

" reload vim configuration
map <Leader>z :so $MYVIMRC<CR>

" Indentation
set expandtab         " Insert spaces instead of tab
set tabstop=4         " Number of spaces for a tab
set shiftwidth=4      " Tab size
set softtabstop=4     " Makes one backspace go back a full 4 spaces
set listchars=tab:»·,trail:·
set list

" switch easily between splits
map <C-h> <C-w>h<C-w>=
map <C-j> <C-w>j<C-w>=
map <C-k> <C-w>k<C-w>=
map <C-l> <C-w>l<C-w>=

" manage tabs
map <Leader>tn :tabn<CR>
map <Leader>tp :tabp<CR>
map <Leader>te :tabe<CR>
map <Leader>tc :tabclose<CR>
map <C-A-Pageup> :tabmove -1<CR>
map <C-A-PageDown> :tabmove +1<CR>
map <C-Pageup> :tabp<CR>
map <C-PageDown> :tabn<CR>
map <C-t> :tabe<CR>
map <C-q> :tabclose<CR>

" manage buffers
map <Leader>sv <C-w>v<CR>
map <Leader>sh <C-w>s<CR>
map <Leader>bc :bdelete<CR>
nmap <Leader>bn :bnext<CR>
nmap <Leader>bp :bprev<CR>
nmap <Leader>bf :bfirst<CR>
nmap <Leader>bl :blast<CR>
" :nmap <Leader>b? :CtrlPBuffer<CR>
:nmap <Leader>b? :Buffers<CR>

" add copy/paste from clipboard
vmap <C-c> y: call system("wl-copy", getreg("\""))<CR>
nmap <C-v> :call setreg("\"",system("wl-paste"))<CR>p
imap <C-v> <Esc><C-v>a
" clear search
nmap <F4> :let @/ = ""<CR><F6>
nmap <F6> :<Backspace>
" escape insert by jk
inoremap jk <Esc>
" replace word under cursor
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
" map double-click to enter in insert mode
nmap <2-LeftMouse> a
" delete everything between current brackets
map <Leader>db v%holc
autocmd BufWritePre * %s/\s\+$//e " remove leading whitespace
" CoC statusline
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" set statusline=%<%f\ %h%m%r%y
"         \%{exists('g:loaded_fugitive')?fugitive#statusline():''}
"         \%=%-14.(%l,%c%V%)\ %P
imap <C-s> <Esc>:w<CR><Insert>


" Sessions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set cursorline
"set cursorcolumn
" last position jump. note that your ~/.viminfo should be owned by you.
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


" Filetype specific
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" JSON
autocmd FileType json syntax match Comment +\/\/.\+$+
" Go
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
autocmd FileType go nmap gtj :CocCommand go.tags.add json<cr>
autocmd FileType go nmap gty :CocCommand go.tags.add yaml<cr>
autocmd FileType go nmap gtm :CocCommand go.tags.add mapstructure<cr>
autocmd FileType go nmap gtx :CocCommand go.tags.clear<cr>
autocmd FileType go nmap gtg :CocCommand go.test.generate.file<cr>

" FZF
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:GotoOrOpen(command, ...)
    for file in a:000
        if a:command == 'e'
            exec 'drop ' . file
        else
            exec "tab drop " . file
        endif
    endfor
endfunction

command! -nargs=+ GotoOrOpen call s:GotoOrOpen(<f-args>)

let g:fzf_action = {
  \ 'enter': 'GotoOrOpen e',
  \ 'ctrl-t': 'GotoOrOpen tab',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_buffers_jump = 1

" nmap <Leader>fg :GFiles<CR>
map <C-p> :Files<CR>

" CoC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_global_extensions = [
    \ 'coc-ultisnips',
    \ 'coc-pairs',
    \ 'coc-prettier',
    \ ]
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> <Leader>gd <Plug>(coc-definition)
nmap <silent> <Leader>gy <Plug>(coc-type-definition)
nmap <silent> <Leader>gi <Plug>(coc-implementation)
nmap <silent> <Leader>gr <Plug>(coc-references)
nmap <silent> <Leader>o :CocList outline<CR>
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Refactor
nmap <F2> <Plug>(coc-rename)
nmap <Leader>cr <Plug>(coc-refactor)
nmap <Leader>f <Plug>(coc-format)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)
" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" `:Prettier to format file`
command! -nargs=0 Prettier :CocCommand prettier.formatFile


" vim-workspace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>w :ToggleWorkspace<CR>
let g:workspace_session_directory = $HOME . '/.vim/sessions/' " save sessions globally
let g:workspace_persist_undo_history = 1  " persist history
let g:workspace_undodir = $HOME . '/.vim/undodir/'
let g:workspace_session_disable_on_args = 1 " disable vim sessions when opening specific file
let g:workspace_autosave = 0
let g:workspace_autosave_ignore = ['gitcommit', 'qf', 'nerdtree', 'tagbar']

" NERDTree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <F3> :NERDTreeToggle<CR>
" open NERDTree automatically
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * NERDTree
" autocmd VimEnter * execute 'NERDTree' | wincmd p
autocmd WinEnter * if winnr('$') == 1 && exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) == 1 | quit | endif

let g:NERDTreeGitStatusWithFlags = 1
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusShowIgnored = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:NERDTreeGitStatusNodeColorization = 1
let g:NERDTreeColorMapCustom = {
    \ "Staged"    : "#0ee375",
    \ "Modified"  : "#d9bf91",
    \ "Renamed"   : "#51C9FC",
    \ "Untracked" : "#FCE77C",
    \ "Unmerged"  : "#FC51E6",
    \ "Dirty"     : "#FFBD61",
    \ "Clean"     : "#87939A",
    \ "Ignored"   : "#808080"
    \ }

let g:NERDTreeIgnore = ['^node_modules$', '^vendor$']
" sync open file with NERDTree
" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction
" Call NERDTreeFind if NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if bufname('%') !~# 'NERD_tree_' && &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction
" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

" NERDCommenter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDSpaceDelims = 1                                             " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1                                         " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'                                       " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1                                          " Set a language to use its alternate delimiters by default
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } } " Add your own custom formats or override the defaults
let g:NERDCommentEmptyLines = 1                                       " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1                                  " Enable trimming of trailing whitespace when uncommenting
let g:NERDToggleCheckAllLines = 1                                     " Enable NERDCommenterToggle to check all selected lines is commented or not


" editorconfig
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" GitGutter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufEnter GitGutterEnable

" EasyAlign
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Beautify
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:beautify#default_outputter = 'current_buffer'
