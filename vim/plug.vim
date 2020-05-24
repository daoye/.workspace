call plug#begin('~/.local/share/nvim/plugged')

" 配色方案
Plug 'lifepillar/vim-solarized8'

" 解决输入法切换的问题
" Plug 'vim-scripts/fcitx.vim.git'

" airline 状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" 自动补全
" if !has('nvim')
" 	Plug 'roxma/vim-hug-neovim-rpc'
" 	Plug 'roxma/nvim-yarp'
" endif
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'prabirshrestha/asyncomplete.vim'

" Python源
" Plug 'deoplete-plugins/deoplete-jedi'

" Python 扩展
Plug 'davidhalter/jedi-vim'

" C# 扩展及源
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'OmniSharp/omnisharp-vim'
Plug 'nickspoons/vim-sharpenup' " omnisharp-vim 的通用配置
Plug 'OrangeT/vim-csharp' " csharp扩展

" 代码片段
" 片段引擎
Plug 'SirVer/ultisnips'
" 代码片段模板
Plug 'honza/vim-snippets'



" 用于突出显示当前自动补全函数的签名
Plug 'Shougo/echodoc.vim'

Plug 'w0rp/ale' " 语法检查

" 文件查找插件，ctrlp的替代品
" Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

" 文件查找
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug '/usr/local/bin/fzf'
Plug 'junegunn/fzf.vim'

" 文件目录
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Dockerfile 语法支持
Plug 'ekalinin/Dockerfile.vim'

" Vim 文件模版
Plug 'aperezdc/vim-template'

" 改善Buf操作
Plug 'fholgado/minibufexpl.vim'

" 文件修改历史查看
Plug 'mbbill/undotree'

" 括号自动完成和编辑
Plug 'tpope/vim-surround'
"
" 注释辅助
Plug 'scrooloose/nerdcommenter'

" 括号自动完成
Plug 'spf13/vim-autoclose'

" GIT支持
Plug 'tpope/vim-fugitive'

" 调试器
Plug 'vim-vdebug/vdebug'

call plug#end()

