lua << EOF
require'nvim-tree'.setup { 
  view = {
    width = 60,
  },
}
EOF

nnoremap <space>e :lua require('nvim-tree').toggle()<CR>

nnoremap <space>f :lua require('nvim-tree').find_file(true)<CR>
" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeFolderIcon guibg=blue
