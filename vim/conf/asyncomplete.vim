" Tab completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

" Force refresh completion
imap <c-space> <Plug>(asyncomplete_force_refresh)

" Auto popup
let g:asyncomplete_auto_popup = 1

set completeopt-=preview

"To auto close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
