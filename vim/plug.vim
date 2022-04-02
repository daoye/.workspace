call plug#begin('~/.local/share/nvim/plugged')

" Vim 中文文档
Plug 'yianwillis/vimcdoc'

" 配色方案
Plug 'morhetz/gruvbox'

" 图标
Plug 'kyazdani42/nvim-web-devicons'

" airline 状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" 快速跳转
Plug 'easymotion/vim-easymotion'
" 文件修改历史查看
Plug 'mbbill/undotree'
" 注释辅助
Plug 'scrooloose/nerdcommenter'
" GIT支持
Plug 'tpope/vim-fugitive'

" 调试器
Plug 'puremourning/vimspector'

" 文本对齐
Plug 'junegunn/vim-easy-align'

" 快速编辑成对的文本
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'


if has('nvim')
    " lsp
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/nvim-lsp-installer'


    " lsp autocomplete
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'

    " lsp snip  
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'rafamadriz/friendly-snippets'

    " treesitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'


    " Auto pairs
    Plug 'windwp/nvim-autopairs'

    " Tmux navigator
    Plug 'christoomey/vim-tmux-navigator'

    Plug 'kyazdani42/nvim-tree.lua'

    " 剪贴板管理
    Plug 'AckslD/nvim-neoclip.lua'

    " Sqlite
    Plug 'tami5/sqlite.lua'

    " 文件查找
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-frecency.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'olacin/telescope-gitmoji.nvim'
    Plug 'TC72/telescope-tele-tabby.nvim'

    " AI pair programmer
    Plug 'github/copilot.vim'

    Plug 'folke/trouble.nvim'
endif

" 括号高亮
Plug 'frazrepo/vim-rainbow'
" 语法高亮
" Plug 'sheerun/vim-polyglot'


call plug#end()
