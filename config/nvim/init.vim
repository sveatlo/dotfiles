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
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'scrooloose/nerdtree'
    Plug 'tsony-tsonev/nerdtree-git-plugin'
    "Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'ryanoasis/vim-devicons'
    Plug 'airblade/vim-gitgutter'
    Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
    Plug 'scrooloose/nerdcommenter'
    Plug 'junegunn/vim-easy-align'
    Plug 'alpaca-tc/beautify.vim'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'liuchengxu/vim-which-key'
    Plug 'Yggdroot/indentLine'

    "Themes
    Plug 'ayu-theme/ayu-vim'
    "Plug 'morhetz/gruvbox'
" Initialize plugin system
call plug#end()


" Theming
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set termguicolors
let ayucolor="mirage"
colorscheme ayu
let g:airline_theme = "ayu"

" General options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:which_key_map =  {}

set autochdir
set backspace=eol,start,indent " allow backspacing over indent, eol, & start
set cindent
set cmdheight=2
set enc=utf-8
set hidden
set history=100
set hlsearch
set ignorecase smartcase
set incsearch
let mapleader=","
set mouse=nvch
set nobackup
set nowritebackup
set number relativenumber
set shortmess+=c
set signcolumn=yes
set titlestring=%f title " Display filename in terminal window
set undolevels=100
set updatetime=300
set whichwrap=b,s,<,>,[,]  " Allow tranversing to prev/next line from beginning/end of line
" Indentation
set expandtab         " Insert spaces instead of tab
set tabstop=4         " Number of spaces for a tab
set shiftwidth=4      " Tab size
set softtabstop=4     " Makes one backspace go back a full 4 spaces
set listchars=tab:»·,trail:·
set list
" reload vim configuration
map <Leader>z :so $MYVIMRC<CR>
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
map <Leader>tw :tabclose<CR>
let g:which_key_map.t = {
    \ 'name': '+tab',
    \ 'n' : 'next tab',
    \ 'p' : 'previous tab',
    \ 'e' : 'new tab',
    \ 'c' : 'close tab',
    \ 'w' : 'close tab'
    \ }
map <C-PageDown> :tabn<CR>
map <C-Pageup> :tabp<CR>
map <C-t> :tabe<CR>
map <C-q> :tabclose<CR>
" manage buffers
:map <Leader>sv <C-w>v<CR>
:map <Leader>sh <C-w>s<CR>
let g:which_key_map.s = {
    \ 'name': '+split',
    \ 'v': 'vertically',
    \ 'h': 'horizontally',
    \ }
:map <Leader>bw :bdelete<CR>
:map <Leader>bd :bdelete<CR>
:map <Leader>bc :bdelete<CR>
:nmap <Leader>bn :bnext<CR>
:nmap <Leader>bp :bprev<CR>
:nmap <Leader>bf :bfirst<CR>
:nmap <Leader>bl :blast<CR>
:nmap <Leader>b? :CtrlPBuffer<CR>
let g:which_key_map.b = {
    \ 'name' : '+buffer' ,
    \ 'd' : ['bd'        , 'delete-buffer']   ,
    \ 'f' : ['bfirst'    , 'first-buffer']    ,
    \ 'l' : ['blast'     , 'last-buffer']     ,
    \ 'n' : ['bnext'     , 'next-buffer']     ,
    \ 'p' : ['bprevious' , 'previous-buffer'] ,
    \ '?' : ['Buffers'   , 'fzf-buffer']      ,
    \ }
" add copy/paste from clipboard (need xclip package)
vmap <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<CR>
nmap <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
imap <C-v> <Esc><C-v>a
" map double-click to enter in insert mode
nmap <2-LeftMouse> a
" delete everything between current brackets
map <C-y> v%holc
" forces (re)indentation of a block of code
nmap <C-i> vip=
autocmd BufWritePre * %s/\s\+$//e " remove leading whitespace
set statusline=%<%f\ %h%m%r%y
        \%{exists('g:loaded_fugitive')?fugitive#statusline():''}
        \%=%-14.(%l,%c%V%)\ %P
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
autocmd FileType go nmap gtx :CocCommand go.tags.clear<cr>


" CoC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-pairs',
    \ 'coc-tsserver',
    \ 'coc-eslint',
    \ 'coc-prettier',
    \ 'coc-json',
    \ 'coc-go',
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
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> <Leader>gd <Plug>(coc-definition)
nmap <silent> <Leader> gy <Plug>(coc-type-definition)
nmap <silent> <Leader>gi <Plug>(coc-implementation)
nmap <silent> <Leader>gr <Plug>(coc-references)
let g:which_key_map.g = {
    \ 'name': '+goto',
    \ 'd': 'definition',
    \ 'y': 'type-definition',
    \ 'i': 'implementation',
    \ 'r': 'references'
    \}
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
" Remap for rename current word
nmap <F2> <Plug>(coc-rename)
" multicursors
hi CocCursorRange guibg=#b16286 guifg=#ebdbb2
nmap <expr> <silent> <C-d> <SID>select_current_word()
function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc
" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)
" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" `:Prettier to format file`
command! -nargs=0 Prettier :CocCommand prettier.formatFile


" NERDTree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap jk <ESC>
nmap <C-e> :NERDTreeToggle<CR>
nmap <F3> :NERDTreeToggle<CR>
" open NERDTree automatically
autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * NERDTree
autocmd VimEnter * execute 'NERDTree' | wincmd p
autocmd WinEnter * if winnr('$') == 1 && exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) == 1 | quit | endif

let g:NERDTreeGitStatusWithFlags = 1
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

let g:NERDTreeIgnore = ['^node_modules$']
" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind if NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction
" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

" NERDCommenter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1


" CtrlP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:ctrlp_use_caching = 0


" GitGutter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufEnter GitGutterEnable

" EasyAlign
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


" WhichKey
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call which_key#register(',', "g:which_key_map")
nnoremap <silent> <leader>      :<c-u>WhichKey ','<CR>
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
