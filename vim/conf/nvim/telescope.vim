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
    file_browser = {
      -- theme = "ivy",
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
}
require('telescope').load_extension('fzf')
require("telescope").load_extension('file_browser')

EOF

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fw <cmd>Telescope grep_string<cr>
nnoremap <leader>ft <cmd>Telescope tags<cr>
nnoremap <leader>f? <cmd>Telescope search_history<cr>
nnoremap <leader>fm <cmd>Telescope marks<cr>
nnoremap <space>e <cmd>Telescope file_browser<cr>
