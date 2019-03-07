syntax enable " 启用语法高亮
filetype on " 启用文件类型检测
set number " 启用行号
set history=1000  " 记录历史的行数
set tabstop=4 " 设置tab键为4个空格
set clipboard=unnamed " 使用系统剪贴板，而不是“+”指令
set shiftwidth=4 " 设置当行之间交错时使用4个空格
let mapleader="," " 修改<leader> 键为,

" 设置python路径
let g:python3_host_prog=expand('~/.virtualenvs/nvim_py3/bin/python')
let g:python_host_prog=expand('~/.virtualenvs/nvim_py2/bin/python')

" 加载插件
source ~/.config/nvim/plug.vim

" 设置主题方案
set background=dark
if $COLORTERM == 'truecolor'
    set termguicolors
else
    set term=xterm
    set t_Co=256
endif
colorscheme solarized8

