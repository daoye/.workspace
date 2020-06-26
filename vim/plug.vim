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

" 自动补全
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" LSP客户端
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" 显示方法签名
Plug 'Shougo/echodoc.vim'

" 代码片段
" Track the engine.
Plug 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'


" 文本内自动补全
Plug 'Shougo/neco-syntax'

" C# 扩展及源
" Plug 'OmniSharp/csharp-language-server-protocol'
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

" Json支持
Plug 'elzr/vim-json'
Plug 'Chiel92/vim-autoformat'

call plug#end()

