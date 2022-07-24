lua << EOF

require'diffview'.setup {
}

EOF


nnoremap <silent> <leader>gg :DiffviewClose <bar> DiffviewFileHistory<cr>
nnoremap <silent> <leader><leader>gg :DiffviewClose <bar> DiffviewOpen<cr>
nnoremap <silent> <leader>gc :DiffviewClose<cr>
