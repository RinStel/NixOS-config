syntax on
set number relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set cursorline
set hlsearch
set incsearch

" --- Gruvbox 核心配置 (透明背景版) ---
if has("termguicolors")
    set termguicolors
endif

set background=dark
let g:gruvbox_contrast_dark = 'hard'

" 核心逻辑：定义一个透明化函数
function! s:transparent_background()
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NonText guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
    highlight Folded guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
    highlight SignColumn guibg=NONE ctermbg=NONE
    " 如果你希望侧边栏（如行号列）也透明
    highlight CursorLineNr guibg=NONE ctermbg=NONE
    highlight Statement guifg=#d3869b guibg=NONE
endfunction

" 1. 尝试加载配色
silent! colorscheme gruvbox

" 2. 立即执行透明化
autocmd ColorScheme * call s:transparent_background()
call s:transparent_background()

" 快捷键：空格取消高亮
nnoremap <space> :nohlsearch<CR>
