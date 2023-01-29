lua << EOF
require("trouble").setup {
    mode = 'document_diagnostics',
    group = true,
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
    use_diagnostic_signs = true
}

vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  {silent = true, noremap = true}
)

vim.keymap.set("n", "<leader>fr", "<cmd>Trouble lsp_references<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>fd", "<cmd>Trouble lsp_definitions<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>ft", "<cmd>Trouble lsp_type_definitions<cr>",
  {silent = true, noremap = true}
)
EOF
