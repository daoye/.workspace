lua << EOF

signature = require'lsp_signature'

signature.setup{
    floating_window = false;
    hint_enable = true, -- virtual hint enable
    hint_prefix = "🎯",  -- Panda for parameter
    hint_scheme = "String",
    max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
    max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    handler_opts = {
        border = "none"   -- double, rounded, single, shadow, none
    },
}
EOF
