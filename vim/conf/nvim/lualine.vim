lua << EOF
local mytheme = require'lualine.themes.solarized_light'

require('lualine').setup {
    options = { theme  = mytheme },
}
EOF
