lua << EOF
    local saga = require 'lspsaga'

    saga.setup {
    }
    
    -- disable default diagnostic, but use lsp_lines
    -- vim.diagnostic.config({ virtual_text = false })
EOF

nnoremap <silent> <A-d> :Lspsaga open_floaterm<CR>
tnoremap <silent> <A-d> <C-\><C-n>:Lspsaga close_floaterm<CR>
