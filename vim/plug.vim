call plug#begin('~/.local/share/nvim/plugged')

" 配色方案
Plug 'lifepillar/vim-solarized8'

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

" Python源
Plug 'deoplete-plugins/deoplete-jedi'

" C#源
Plug 'OmniSharp/omnisharp-vim'

Plug 'w0rp/ale' " 语法检查

" 文件查找插件，ctrlp的替代品
" Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

" 文件查找
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" 文件目录
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Dockerfile 语法支持
Plug 'ekalinin/Dockerfile.vim'

" Vim 文件模版
Plug 'aperezdc/vim-template'

runtime! conf/*.vim

call plug#end()


call deoplete#custom#option('profile', v:true)
call deoplete#custom#source('jedi', 'is_debug_enabled', 1)
call deoplete#enable_logging('DEBUG', '/tmp/deoplete.log')
