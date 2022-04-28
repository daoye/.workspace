lua << EOF
  require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

" Vim Script
" nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>le <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader><leader>le <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>lq <cmd>TroubleToggle quickfix<cr>
" nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
