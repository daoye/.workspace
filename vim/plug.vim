call plug#begin('~/.local/share/nvim/plugged')

" Vim 中文文档
Plug 'yianwillis/vimcdoc'

" 配色方案
Plug 'morhetz/gruvbox'

" 图标
Plug 'kyazdani42/nvim-web-devicons'

" 文件修改历史查看
Plug 'mbbill/undotree'
" 注释辅助
" Plug 'scrooloose/nerdcommenter'

" GIT支持
" Plug 'tpope/vim-fugitive'


" 文本对齐
Plug 'junegunn/vim-easy-align'

" 快速编辑成对的文本
" Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" Merge tool
" Plug 'samoshkin/vim-mergetool'

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
    Plug 'rakr/vim-one'

    Plug 'romgrk/barbar.nvim'

    " lsp
    " Plug 'williamboman/nvim-lsp-installer'
    Plug 'lewis6991/hover.nvim'
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'jose-elias-alvarez/null-ls.nvim'
    Plug 'jay-babu/mason-null-ls.nvim'
    Plug 'j-hui/fidget.nvim'

    " lsp ui extends
    " Plug 'glepnir/lspsaga.nvim', { 'branch' : 'main' }
    " Plug 'ray-x/lsp_signature.nvim'

    " lsp autocomplete
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
    " Plug 'hrsh7th/cmp-copilot'

    " lsp snip  
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'rafamadriz/friendly-snippets'



    " 调试器
    Plug 'mfussenegger/nvim-dap'
    Plug 'rcarriga/nvim-dap-ui'
    Plug 'theHamsta/nvim-dap-virtual-text'
    Plug 'mfussenegger/nvim-dap-python'
    Plug 'rcarriga/cmp-dap'


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
    Plug 'nvim-telescope/telescope-ui-select.nvim'
    Plug 'nvim-telescope/telescope-smart-history.nvim'
    " Plug 'nvim-telescope/telescope-dap.nvim'

    " dashboard
    " Plug 'glepnir/dashboard-nvim'
    "
    " UI extend
    Plug 'folke/noice.nvim'
    Plug 'MunifTanjim/nui.nvim'
    Plug 'rcarriga/nvim-notify'
    Plug 'folke/trouble.nvim'
    Plug 'RRethy/vim-illuminate'

    " Git
    Plug 'sindrets/diffview.nvim'
    Plug 'lewis6991/gitsigns.nvim'

    " Color text to color background
    Plug 'norcalli/nvim-colorizer.lua'

    "marks
    Plug 'chentoast/marks.nvim'

    " motion
    Plug 'ggandor/lightspeed.nvim'

    " Surround
    Plug 'kylechui/nvim-surround'

    " Comment
    Plug 'numToStr/Comment.nvim'
endif

call plug#end()
