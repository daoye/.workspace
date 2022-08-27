lua << EOF

require'diffview'.setup { }

EOF


nnoremap <silent> <leader>gg :DiffviewFileHistory %<cr>
nnoremap <silent> <leader><leader>gg :DiffviewOpen<cr>
nnoremap <silent> <leader>gc :DiffviewClose<cr>
