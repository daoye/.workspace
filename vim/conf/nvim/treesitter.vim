" set foldminlines=1
" set foldnestmax=20
" set foldlevel=10
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99

lua <<EOF
require'nvim-treesitter.configs'.setup {
--  ensure_installed = "all",

  sync_install = false,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = false
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim 
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },

    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["<leader>j"] = "@function.outer",
        ["<leader>J"] = "@class.outer",
      },
      goto_next_end = {
        ["]|"] = "@function.outer",
        ["]C"] = "@class.outer",
      },
      goto_previous_start = {
        ["<leader>k"] = "@function.outer",
        ["<leader>K"] = "@class.outer",
      },
      goto_previous_end = {
        ["[|"] = "@function.outer",
        ["[C"] = "@class.outer",
      },
    },


    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },

  },
}
EOF
