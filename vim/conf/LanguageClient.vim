" 始终显示符号列
set signcolumn=yes

" 为语言指定Language server和server的参数
let g:LanguageClient_serverCommands = {
            \ 'cpp': ['ccls', '--log-file=/tmp/cq.log'],
            \ 'c': ['ccls', '--log-file=/tmp/cq.log'],
            \ 'python': ['pyls']
            \ }

" 是否为Language server载入配置文件，其实默认就是1,可以忽略
let g:LanguageClient_loadSettings = 1
" server配置文件的位置
let g:LanguageClient_settingsPath = "$HOME/.config/nvim/lsp_setting.json"

" 把Server的补全API提交给Vim
" 一般有deoplete就可以用了，加上一条以防万一。
set completefunc=LanguageClient#complete
" 把Server的格式化API提交给Vim
set formatexpr=LanguageClient_textDocument_rangeFormatting()

function SetLSPShortcuts()
	nnoremap <F5> :call LanguageClient_contextMenu()<CR>
	nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
	nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
	nnoremap <silent> gt :call LanguageClient#textDocument_typeDefinition()<CR>
	nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
	nnoremap <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
	nnoremap <silent> fs :call LanguageClient#textDocument_formatting()<CR>
	nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
endfunction()

augroup LSP
  autocmd!
  autocmd FileType cpp,c,py call SetLSPShortcuts()
augroup END
