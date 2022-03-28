lua << EOF
require("telescope").setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    gitmoji = {
        action = function(entry)
            -- entry = {
            --     display = "🎨 Improve structure / format of the code.",
            --     index = 1,
            --     ordinal = "Improve structure / format of the code.",
            --     value = "🎨"
            -- }
            vim.ui.input({ prompt = "Enter commit msg: " .. entry.value .. " "}, function(msg)
                if not msg then
                    return
                end
                vim.cmd(':G commit -m "' .. entry.value .. ' ' .. msg .. '"')
            end)
        end,
    },
  },
}
require('telescope').load_extension('fzf')
require('telescope').load_extension("gitmoji")
-- require('telescope').extensions.gitmoji.gitmoji()
EOF

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fw <cmd>Telescope grep_string<cr>
nnoremap <leader>ft <cmd>Telescope tags<cr>
nnoremap <leader>fh <cmd>Telescope search_history<cr>
nnoremap <leader>fm <cmd>Telescope marks<cr>
nnoremap <leader><tab> <cmd>Telescope resume<cr>
nnoremap <space><space> <cmd>Telescope spell_suggest<cr>
nnoremap <leader>fk <cmd>Telescope keymaps<cr>
nnoremap <leader>f? <cmd>Telescope help_tags<cr>
nnoremap <space>cm <cmd>Telescope gitmoji<cr>

" lsp mappings
nnoremap <leader>ls <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader><leader>ls <cmd>Telescope lsp_workspace_symbols<cr>
nnoremap <leader>la <cmd>Telescope lsp_code_actions<cr>
vnoremap <leader>la <cmd>Telescope lsp_range_code_actions<cr>
nnoremap <leader>lr <cmd>Telescope lsp_references<cr>
nnoremap <leader>le <cmd>Telescope diagnostics bufnr=0<cr>
nnoremap <leader><leader>le <cmd>Telescope diagnostics<cr>
nnoremap <leader>li <cmd>Telescope lsp_implementations<cr>
nnoremap <leader>ld <cmd>Telescope lsp_definitions<cr>
nnoremap <leader><leader>ld <cmd>Telescope lsp_type_definitions<cr>
