" Enable default mapping
let g:vimspector_enable_mappings = 'HUMAN'



" Improve neovim 
"
" mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)
" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

" Up/Down stack
nmap <LocalLeader><F11> <Plug>VimspectorUpFrame
xmap <LocalLeader><F12> <Plug>VimspectorDownFrame

" clear breakpoints
nmap <Leader><F2> :call vimspector#ClearBreakpoints()<CR>
xmap <Leader><F2> :call vimspector#ClearBreakpoints()<CR>

" Reset windows 
nmap <Leader><F3> :VimspectorReset<CR>
xmap <Leader><F3> :VimspectorReset<CR>



" Improve neovim 

" load package
" packadd! vimspector
