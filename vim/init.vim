set encoding=UTF-8
syntax enable " 启用语法高亮
filetype plugin indent on " 启用文件类型检测
" abandoned的Buffer隐藏起来，这是vim的设置。
" 如果没有这个设置，修改过的文件需要保存了才能换buffer
" 这会影响全局重命名，因为Vim提示保存因此打断下一个文件的重命名。
set hidden
set number " 启用行号
set history=1000  " 记录历史的行数
set autoread
set diffopt=internal,filler,closeoff,algorithm:minimal

" 设置tab键为4个空格
set tabstop=4
set shiftwidth=4 " 设置当行之间交错时使用4个空格
set expandtab
set clipboard=unnamedplus

" Always show the signcolumn
set signcolumn=yes
set cmdheight=2

let mapleader="," " 修改<leader> 键为,

" 设置python路径
if has('unix')
    let g:python_host_prog = '/usr/bin/python'
    let g:python3_host_prog = '/usr/bin/python3'
else
    let g:python_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3'
endif

if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
endif

if (has("termguicolors"))
    set termguicolors
else
    set term=xterm
    set t_Co=256
endif

runtime! lua/init.lua

" 加载插件
source ~/.config/nvim/plug.vim

" 加载插件自定义配置 
runtime! conf/*.vim

if has('nvim')
    runtime! conf/nvim/*.vim
endif


nnoremap <esc> :noh<CR>
noremap <C-s> :w<CR>

" 改变窗口大小
nmap <S-Up> :res +5<CR>
nmap <S-Down> :res -5<CR>
nmap <S-Left> :vert res -5<CR>
nmap <S-Right> :vert res +5<CR>

" 设置vim透明
hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
