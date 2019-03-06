syntax enable " 启用语法高亮
 " 使用系统剪贴板，而不是“+”指令
set clipboard=unnamed
nnoremap <expr> p (v:register == '"' && &clipboard =~ 'unnamed' ? '"*p' : '"' . v:register . 'p')
filetype on " 启用文件类型检测
set number " 启用行号
set history=1000  " 记录历史的行数
set tabstop=4 " 设置tab键为4个空格
set shiftwidth=4 " 设置当行之间交错时使用4个空格
let mapleader="," " 修改<leader> 键为,


call plug#begin('~/.local/share/nvim/plugged')

" 配色方案
Plug 'daoye/vim-colors-solarized'

" 解决输入法切换的问题
" Plug 'vim-scripts/fcitx.vim.git'

" airline 状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" 自动补全
if !has('nvim')
	Plug 'roxma/vim-hug-neovim-rpc'
	Plug 'roxma/nvim-yarp'
endif
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
source ~/.config/nvim/conf/deoplete.vim

" 代码片段
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
"source ~/.config/nvim/ultisnips.vim

" c# 语法自动补全支持
Plug 'OmniSharp/omnisharp-vim'
source ~/.config/nvim/conf/omnisharp.vim

" 语法检查
Plug 'w0rp/ale'

" 文件查找插件，ctrlp的替代品
" Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

" 文件查找
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
source ~/.config/nvim/conf/fzf.vim

" 文件目录插件
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
source ~/.config/nvim/conf/nerdtree.vim

" Dockerfile 语法支持
Plug 'ekalinin/Dockerfile.vim'

" Vim 文件模版
Plug 'aperezdc/vim-template'
source ~/.config/nvim/conf/vim-template.vim

call plug#end()

" 设置主题方案
"let g:solarized_termcolors=256
set background=dark
if $COLORTERM == 'truecolor'
    set termguicolors
else
    set term=xterm
    set t_Co=256
endif
colorscheme solarized
