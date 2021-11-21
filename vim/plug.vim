call plug#begin('~/.local/share/nvim/plugged')

" 配色方案
" Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'

" 解决输入法切换的问题
" Plug 'vim-scripts/fcitx.vim.git'

" airline 状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" 快速跳转
Plug 'easymotion/vim-easymotion'
" Vim 文件模版
" Plug 'aperezdc/vim-template'
" 改善Buf操作
" Plug 'fholgado/minibufexpl.vim'
" 文件修改历史查看
Plug 'mbbill/undotree'
" 括号自动完成和编辑
Plug 'tpope/vim-surround'
" 注释辅助
Plug 'scrooloose/nerdcommenter'
" 括号自动完成
Plug 'spf13/vim-autoclose'
" GIT支持
Plug 'tpope/vim-fugitive'
" 文件查找
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

" 文件目录
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
" 图标
" Plug 'ryanoasis/vim-devicons'
" 括号高亮
Plug 'frazrepo/vim-rainbow'


" 自动补全
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" 语法检查
Plug 'w0rp/ale' 
" 代码片段
Plug 'honza/vim-snippets'

" 语法高亮
Plug 'sheerun/vim-polyglot'

" Debugger
Plug 'puremourning/vimspector'

call plug#end()

" Coc 扩展
let g:coc_global_extensions=["coc-json","coc-css", "coc-marketplace", "coc-omnisharp", "coc-python",
                            \"coc-snippets",
                            \"coc-sql","coc-xml",
                            \"coc-yaml","coc-markdownlint","coc-html","coc-highlight",
                            \"coc-actions",
                            \"coc-tag", "coc-word", "coc-emoji", "coc-syntax"]

