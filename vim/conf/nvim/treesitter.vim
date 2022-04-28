set foldlevel=99
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>',
    },
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
        ["<leader>p"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>P"] = "@parameter.inner",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["<M-j>"] = "@function.outer",
        ["<S-j>"] = "@class.outer",
      },
      goto_next_end = {
        ["<M-J>"] = "@function.outer",
        ["<S-J>"] = "@class.outer",
      },
      goto_previous_start = {
        ["<M-k>"] = "@function.outer",
        ["<S-k>"] = "@class.outer",
      },
      goto_previous_end = {
        ["<M-K>"] = "@function.outer",
        ["<S-K>"] = "@class.outer",
      },
    },


   -- lsp_interop = {
   --   enable = true,
   --   border = 'none',
   --   peek_definition_code = {
   --     ["<leader>df"] = "@function.outer",
   --     ["<leader>dF"] = "@class.outer",
   --   },
   -- },

  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  autotag = {
    enable = true,
  }
}
EOF
