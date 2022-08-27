lua << EOF
local mytheme = require'lualine.themes.onedark'

require('lualine').setup {
    options = { theme  = mytheme },
}
EOF
