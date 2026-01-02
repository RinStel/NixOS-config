" ==================== 插件管理 ====================
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'tpope/vim-commentary'
call plug#end()

let mapleader = ","

syntax on
set number relativenumber
set tabstop=4 shiftwidth=4 expandtab
set autoindent smartindent
set cursorline
set hlsearch incsearch
set ignorecase smartcase
set encoding=utf-8
set fileencoding=utf-8
set hidden
set noswapfile
set updatetime=300

if has("termguicolors")
    set termguicolors
endif

set background=dark

" ==================== 透明背景函数 ====================
function! s:apply_transparent_bg() abort
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NonText guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
    highlight Folded guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
    highlight SignColumn guibg=NONE ctermbg=NONE
    highlight CursorLineNr guibg=NONE ctermbg=NONE
    highlight VertSplit guibg=NONE ctermbg=NONE
    highlight TabLineFill guibg=NONE ctermbg=NONE
endfunction

autocmd ColorScheme * call s:apply_transparent_bg()
call s:apply_transparent_bg()

" ==================== 主题切换功能 ====================
let g:current_theme = 'catppuccin'  " 默认启动主题，可改为 'gruvbox'

function! ToggleTheme() abort
    if g:current_theme == 'catppuccin'
        " 切换到 Gruvbox
        let g:gruvbox_contrast_dark = 'soft'
        let g:gruvbox_italic = 1
        let g:gruvbox_transparent_bg = 1
        colorscheme gruvbox
        let g:airline_theme = 'gruvbox'
        let g:current_theme = 'gruvbox'
        echo "Theme: Gruvbox (soft dark)"
    else
        " 切换到 Catppuccin Mocha
        colorscheme catppuccin_mocha
        " Catppuccin 的 airline 主题通常自动匹配，如果不自动可以强制指定
        " let g:airline_theme = 'catppuccin_mocha'
        let g:current_theme = 'catppuccin'
        echo "Theme: Catppuccin Mocha"
    endif
endfunction

" 快捷键：按 <Leader>t 切换主题（即 ,t）
nnoremap <silent> <Leader>t :call ToggleTheme()<CR>

" 如果你更喜欢用 F4 切换（不占用 Leader）
" nnoremap <silent> <F4> :call ToggleTheme()<CR>

" ==================== Airline 配置 ====================
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'

" 初始主题（根据 g:current_theme 变量自动加载）
if g:current_theme == 'gruvbox'
    let g:gruvbox_contrast_dark = 'soft'
    let g:gruvbox_italic = 1
    let g:gruvbox_transparent_bg = 1
    silent! colorscheme gruvbox
    let g:airline_theme = 'gruvbox'
else
    silent! colorscheme catppuccin_mocha
endif

" ==================== 其他快捷键 ====================
nnoremap <space> :nohlsearch<CR>
nnoremap <F2> :set number! relativenumber!<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

if has("autocmd")
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
endif
