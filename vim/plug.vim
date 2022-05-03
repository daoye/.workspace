call plug#begin('~/.local/share/nvim/plugged')

" Vim 中文文档
Plug 'yianwillis/vimcdoc'

" 配色方案
Plug 'morhetz/gruvbox'

" 图标
Plug 'kyazdani42/nvim-web-devicons'

" airline 状态栏
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
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

" Merge tool
Plug 'samoshkin/vim-mergetool'

if has('nvim')
    " lua thirdpart library
    Plug 'nvim-lua/plenary.nvim'

    " treesitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'romgrk/nvim-treesitter-context'
    " vim-rainbow
    Plug 'p00f/nvim-ts-rainbow'

    " Status line
    Plug 'nvim-lualine/lualine.nvim'

    " Theme
    Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
    Plug 'sainnhe/sonokai'
    Plug 'shaunsingh/nord.nvim'
    Plug 'ishan9299/nvim-solarized-lua'

    Plug 'romgrk/barbar.nvim'

    " lsp
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/nvim-lsp-installer'
    Plug 'j-hui/fidget.nvim'

    " lsp ui extends
    Plug 'tami5/lspsaga.nvim'
    Plug 'ray-x/lsp_signature.nvim'

    " lsp autocomplete
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'

    "Diiagnostic
    Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'

    " lsp snip  
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'rafamadriz/friendly-snippets'
    Plug 'RRethy/vim-illuminate'

    " Auto pairs
    Plug 'windwp/nvim-autopairs'
    Plug 'windwp/nvim-ts-autotag'

    " Prevew code 
    Plug 'rmagatti/goto-preview'

    " Arg join
    Plug 'AckslD/nvim-trevJ.lua'

    " Tmux navigator
    Plug 'christoomey/vim-tmux-navigator'

    Plug 'kyazdani42/nvim-tree.lua'

    " 剪贴板管理
    Plug 'AckslD/nvim-neoclip.lua'

    " Sqlite
    Plug 'tami5/sqlite.lua'

    " 文件查找
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-frecency.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'olacin/telescope-gitmoji.nvim'
    Plug 'TC72/telescope-tele-tabby.nvim'

    " dashboard
    Plug 'glepnir/dashboard-nvim'

    " AI pair programmer
    Plug 'github/copilot.vim'

    Plug 'folke/trouble.nvim'

    " Git
    Plug 'sindrets/diffview.nvim'
    Plug 'lewis6991/gitsigns.nvim'


    " Color support
    Plug 'norcalli/nvim-colorizer.lua'

    " Cursor focus
    Plug 'edluffy/specs.nvim'

    " batch move
    Plug 'booperlv/nvim-gomove'

    "marks
    Plug 'chentau/marks.nvim'

    " motion
    Plug 'ggandor/lightspeed.nvim'

    "fold
    Plug 'anuvyklack/nvim-keymap-amend'
    Plug 'anuvyklack/pretty-fold.nvim'
endif

call plug#end()
