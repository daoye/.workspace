let g:gruvbox_invert_selection=0
lua << EOF
require("telescope").setup {
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous"
      }
    },
    history = {
      path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
      limit = 100,
    }
  },
  pickers = {
    git_branches = {
        mappings = {
          i = {
            ["<C-Z>"] = "git_delete_branch",
            ["<C-D>"] = "preview_scrolling_down",
          },
          n = {
            ["<C-Z>"] = "git_delete_branch",
            ["<C-D>"] = "preview_scrolling_down",
          },
        }
    }
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
            -- even more opts
      }
    },
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    frecency = {
      -- db_root = os.getenv("HOME") .. "/.frecency/db",
      show_scores = true,
      show_unindexed = true,
      ignore_patterns = {"*.git/*", "*/tmp/*"},
      disable_devicons = false,
      workspaces = {
        ["conf"]    = os.getenv("HOME") .. "/.config",
        ["data"]    = os.getenv("HOME") .. "/.local/share",
        ["project"] = os.getenv("HOME") .. "/newegg",
        ["wiki"]    = os.getenv("HOME") .. "/wiki",
      }
    }
  },
}
require('telescope').load_extension("frecency")
require('telescope').load_extension('fzf')
require('telescope').load_extension('neoclip')
require("telescope").load_extension("ui-select")
require('telescope').load_extension('smart_history')
EOF

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fw <cmd>Telescope grep_string<cr>
nnoremap <space>ff <cmd>Telescope current_buffer_fuzzy_find fuzzy=true<cr>
nnoremap <leader>fh <cmd>Telescope search_history<cr>
nnoremap <leader>fm <cmd>Telescope marks<cr>
nnoremap <leader><tab> <cmd>Telescope resume<cr>
" nnoremap <space><space> <cmd>Telescope spell_suggest<cr>
nnoremap <leader>fk <cmd>Telescope keymaps<cr>
nnoremap <leader>f? <cmd>Telescope help_tags<cr>
" nnoremap <leader><space> <cmd>Telescope frecency<cr>

" extensions

" lsp mappings
nnoremap <leader>ls <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader><leader>ls <cmd>Telescope lsp_workspace_symbols<cr>
nnoremap <leader>lr <cmd>Telescope lsp_references<cr>
" nnoremap <leader>le <cmd>Telescope diagnostics bufnr=0<cr>
" nnoremap <leader><leader>le <cmd>Telescope diagnostics<cr>
" nnoremap <leader>li <cmd>Telescope lsp_implementations<cr>
" nnoremap <leader>ld <cmd>Telescope lsp_definitions<cr>
" nnoremap <leader><leader>ld <cmd>Telescope lsp_type_definitions<cr>
" nnoremap <leader>lc <cmd>Telescope git_bcommits<cr>
" nnoremap <leader><leader>lc <cmd>Telescope git_commits<cr>
nnoremap <leader>lb <cmd>Telescope git_branches<cr>
