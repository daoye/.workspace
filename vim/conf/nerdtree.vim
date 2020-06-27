" 自动打开目录浏览工具
"autocmd vimenter * NERDTree

" 如果vim没有指定文件，则自动打开目录浏览
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


" 如果用VIM打开一个目录，则自动打开目录浏览
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" 如果所有其他窗口都关闭，则自动关闭vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" 在所有tab中自动打开tree
"let g:nerdtree_tabs_open_on_console_startup=1

" map <leader>e :NERDTreeToggle<CR>
map <Leader>e <plug>NERDTreeTabsToggle<CR>

