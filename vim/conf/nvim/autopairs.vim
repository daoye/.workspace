lua << EOF
local autopairs = require('nvim-autopairs')
local cmp = require('cmp')
local autopairs_cmp = require('nvim-autopairs.completion.cmp')

autopairs.setup {}
cmp.event:on( 'confirm_done', autopairs_cmp.on_confirm_done({  map_char = { tex = '' } }))
EOF
