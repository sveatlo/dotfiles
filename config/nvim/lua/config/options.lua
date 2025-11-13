--
-- Main configuration and general options
--

local opt = vim.opt
local wopt = vim.wo
local fn = vim.fn

-- general
opt.encoding = "utf-8"
opt.backspace = "eol,start,indent" -- allow backspacing over indent, eol, and start
opt.mouse = "nvch"
opt.cmdheight = 1
opt.autoread = true
opt.hidden = true -- enable hidden buffers
opt.history = 1000
opt.undofile = true -- save history undo file
opt.updatetime = 250
opt.timeoutlen = 400 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.ttimeoutlen = 0 -- Time in milliseconds to wait for a key code sequence to complete
opt.whichwrap = "b,s,<,>,[,]"
-- opt.clipboard:append("unnamedplus") -- use system clipboard
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.winborder = "rounded"

-- search
opt.hlsearch = true -- highlight on search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- numbering
opt.number = true
opt.relativenumber = true

-- indentation
opt.cindent = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.list = true
opt.listchars = "tab:»·,trail:·,extends:>,precedes:<"

-- folding
opt.foldenable = true
opt.foldmethod = "manual"
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"

-- completion
opt.wildmode = "full"
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
opt.wildignorecase = true
opt.wildignore = [[
.git,.hg,.svn
*.aux,*.out,*.toc
*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
*.mp3,*.oga,*.ogg,*.wav,*.flac
*.eot,*.otf,*.ttf,*.woff
*.doc,*.pdf,*.cbr,*.cbz
*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
*.swp,.lock,.DS_Store,._*
*/tmp/*,*.so,*.swp,*.zip,**/node_modules/**,**/target/**,**.terraform/**"
]]

-- ui
opt.title = true
opt.titlestring = "nvim - %{getcwd()} - %f"
opt.signcolumn = "yes"
opt.termguicolors = true
-- opt.lazyredraw = true -- do not redraw screen while running macros
opt.conceallevel = 0 -- minimal conceal level so that `` is visible in markdown
opt.scrolloff = 8 -- Minimal number of screen lines to keep above and below the cursor

--Remap leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.keymap.set({ "n", "v" }, ",", "<Nop>", { silent = true })

