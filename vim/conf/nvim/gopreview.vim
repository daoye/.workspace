lua << EOF
require('goto-preview').setup { }
EOF

" nnoremap <leader>gd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
" nnoremap <leader>gi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
" nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
" Only set if you have telescope installed
" nnoremap <leader>gr <cmd>lua require('goto-preview').goto_preview_references()<CR>
