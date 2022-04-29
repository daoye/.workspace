lua << EOF
vim.diagnostic.config({ virtual_text = false, virtual_lines = {prefix = "🤮"} })
require("lsp_lines").register_lsp_virtual_lines()
EOF
