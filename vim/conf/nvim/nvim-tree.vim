lua << EOF
require'nvim-tree'.setup { }
EOF

nnoremap <space>e :lua require('tree').toggle()<CR>

nnoremap <space>f :lua require('tree').open()<CR>
" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeFolderIcon guibg=blue
