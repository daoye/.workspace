" lua << EOF
"     local saga = require 'lspsaga'
"
"
"     saga.init_lsp_saga {
"          rename_action_keys = {
"            quit = 'q',exec = '<CR>'
"          },
"     }
" EOF
"
" nnoremap <silent><leader>la :Lspsaga code_action<CR>
" vnoremap <silent><leader>la :<C-U>Lspsaga range_code_action<CR>
" nnoremap <silent>K :Lspsaga hover_doc<CR>
"
" nnoremap <silent><leader>rn :Lspsaga rename<CR>
" nnoremap <silent> gp :Lspsaga preview_definition<CR>
