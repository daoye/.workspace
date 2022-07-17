lua << EOF
require('trevj').setup({
})
EOF

nnoremap <leader>j :lua require('trevj').format_at_cursor()<cr>
