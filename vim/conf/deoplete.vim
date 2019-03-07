let g:deoplete#enable_at_startup = 1

let g:deoplete#sources = {}
let g:deoplete#sources._=['buffer', 'ultisnips', 'file', 'dictionary']
"let g:deoplete#sources.clojure=['omni', 'file']
let g:deoplete#sources.clojure=['async_clj', 'file', 'dictionary', 'ultisnips']
let g:deoplete#sources.cs = ['omni', 'file', 'buffer', 'ultisnips']

let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns.cs = ['\w*']
let g:deoplete#omni#input_patterns.clojure = ['\w*']

let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns.clojure = '[\w!$%&*+/:<=>?@\^_~\-\.]*'

" Use smartcase.
let g:deoplete#enable_smart_case = 1

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#close_popup() . "\<CR>"
endfunction

autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
