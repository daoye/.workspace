lua << EOF

local saga = require 'lspsaga'

saga.init_lsp_saga({
    diagnostic_header = { '💩', '🈲', '', 'ﴞ' },
    border_style = 'rounded',
    move_in_saga = { prev = '<C-u>',next = '<C-d>'},
    rename_action_quit = "<ESC>",
})


EOF
