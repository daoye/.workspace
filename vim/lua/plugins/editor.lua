local Util = require("util")

return {
  -- file tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      sort_by = "case_sensitive",
      select_prompts = true,
      disable_netrw = true,
      reload_on_bufenter = true,
      view = {
        width = 50,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.del("n", "g?", { buffer = bufnr })
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
      end,
    },

    keys = {
      {
        "<space>f",
        function()
          require("nvim-tree.api").tree.open({ find_file = true })
        end,
        desc = "Explorer focus current file",
      },
      {
        "<space>e",
        function()
          require("nvim-tree.api").tree.toggle()
        end,
        desc = "Explorer",
      },
    },

    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("nvim-tree")
        end
      end
    end,
  },

  --bufer line
  {
    "romgrk/barbar.nvim",
    event = "VeryLazy",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      -- stylua: ignore
      { "<A-,>", "<Cmd>BufferPrevious<CR>", mode = "n", desc = "Previous buffer" },
      { "<A-.>", "<Cmd>BufferNext<CR>", mode = "n", desc = "Next buffer" },
      { "<A-<>", "<Cmd>BufferMovePrevious<CR>", mode = "n", desc = "Move buffer to previous" },
      { "<A->>", "<Cmd>BufferMoveNext<CR>", mode = "n", desc = "Move buffer to next" },
      { "<A-1>", "<Cmd>BufferGoto 1<CR>", mode = "n", desc = "Move to the 1 buffer" },
      { "<A-2>", "<Cmd>BufferGoto 2<CR>", mode = "n", desc = "Move to the 2 buffer" },
      { "<A-3>", "<Cmd>BufferGoto 3<CR>", mode = "n", desc = "Move to the 3 buffer" },
      { "<A-4>", "<Cmd>BufferGoto 4<CR>", mode = "n", desc = "Move to the 4 buffer" },
      { "<A-5>", "<Cmd>BufferGoto 5<CR>", mode = "n", desc = "Move to the 5 buffer" },
      { "<A-6>", "<Cmd>BufferGoto 6<CR>", mode = "n", desc = "Move to the 6 buffer" },
      { "<A-7>", "<Cmd>BufferGoto 7<CR>", mode = "n", desc = "Move to the 7 buffer" },
      { "<A-8>", "<Cmd>BufferGoto 8<CR>", mode = "n", desc = "Move to the 8 buffer" },
      { "<A-9>", "<Cmd>BufferGoto 9<CR>", mode = "n", desc = "Move to the 9 buffer" },
      { "<A-0>", "<Cmd>BufferLast<CR>", mode = "n", desc = "Move to the last buffer" },
      { "<A-p>", "<Cmd>BufferPin<CR>", mode = "n", desc = "Pin the buffer" },
      { "<A-c>", "<Cmd>BufferClose<CR>", mode = "n", desc = "Close the buffer" },
      { "<C-p>", "<Cmd>BufferPick<CR>", mode = "n", desc = "Pick buffers" },
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      focus_on_close = "previous",
      sidebar_filetypes = {
        -- Use the default values: {event = 'BufWinLeave', text = nil}
        NvimTree = true,
      },
    },
  },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    opts = {
      find_engine = {
        -- rg is map with finder_cmd
        ["rg"] = {
          options = {
            ["ignore-case"] = {
              value = "--ignore-case",
              icon = "[I]",
              desc = "ignore case",
            },
            ["hidden"] = {
              value = "--hidden",
              desc = "hidden file",
              icon = "[H]",
            },
            ["word"] = {
              value = "--word-regexp",
              icon = "[W]",
              desc = "match word",
            },
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
        { "<leader>sw", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
        { "<leader>sf", function() require("spectre").open_file_search({select_word=true}) end, desc = "Replace in current file(Spectre)" },
    },
  },

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    keys = {
      -- { "<leader>fa", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
      { "<leader>fg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
      { "<leader>fG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader><space>", Util.telescope("files"), desc = "Find Files (root dir)" },
      -- find
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
      { "<leader>fF", Util.telescope("find_files"), desc = "Find All Files (root dir)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>f?", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>fw", Util.telescope("grep_string"), desc = "Word (root dir)" },
      { "<leader>fW", Util.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
      -- search
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      -- { "<leader>sb",      "<cmd>Telescope current_buffer_fuzzy_find<cr>",            desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      {
        "<leader>sH",
        "<cmd>Telescope highlights<cr>",
        desc = "Search Highlight Groups",
      },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      {
        "<leader>uC",
        Util.telescope("colorscheme", { enable_preview = true }),
        desc = "Colorscheme with preview",
      },

      {
        "<space>ff",
        "<cmd>Telescope current_buffer_fuzzy_find fuzzy=true<cr>",
        desc = "Search in currentfile",
        mode = { "n", "v" },
      },

      {
        "<leader>ls",
        Util.telescope("lsp_document_symbols", {
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        }),
        desc = "Goto Symbol",
      },
      {
        "<leader><leader>ls",
        Util.telescope("lsp_dynamic_workspace_symbols", {
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        }),
        desc = "Goto Symbol (Workspace)",
      },
    },
    opts = function(p, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          wrap_results = true,
          mappings = {
            i = {
              ["<c-t>"] = function(...)
                return require("trouble.providers.telescope").open_with_trouble(...)
              end,
              ["<a-t>"] = function(...)
                return require("trouble.providers.telescope").open_selected_with_trouble(...)
              end,
              ["<a-i>"] = function()
                Util.telescope("find_files", { no_ignore = true })()
              end,
              ["<a-h>"] = function()
                Util.telescope("find_files", { hidden = true })()
              end,
              ["<C-Down>"] = function(...)
                return require("telescope.actions").cycle_history_next(...)
              end,
              ["<C-Up>"] = function(...)
                return require("telescope.actions").cycle_history_prev(...)
              end,
              ["<C-d>"] = function(...)
                return require("telescope.actions").preview_scrolling_down(...)
              end,
              ["<C-u>"] = function(...)
                return require("telescope.actions").preview_scrolling_up(...)
              end,
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
            n = {
              ["q"] = function(...)
                return require("telescope.actions").close(...)
              end,
            },
          },
          borderchars = {
            { "-", "|", "-", "|", "+", "+", "+", "+" },
            prompt = { "-", "|", " ", "│", "+", "+", "|", "|" },
            results = { "-", "|", "-", "|", "+", "+", "+", "+" },
            preview = { "-", "|", "-", "|", "+", "+", "+", "+" },
          },
          dynamic_preview_title = true,
          layout_strategy = "center",
          layout_config = {
            width = 0.95,
            height = 0.6,
            anchor = "N",
          },
        },
        extensions = {
          -- ["ui-select"] = {
          --   require("telescope.themes").get_dropdown({
          --     -- even more opts
          --   }),
          -- },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          frecency = {
            show_scores = true,
            show_unindexed = true,
            ignore_patterns = { "*.git/*", "*/tmp/*" },
            disable_devicons = false,
            workspaces = {
              ["conf"] = os.getenv("HOME") .. "/.config",
              ["data"] = os.getenv("HOME") .. "/.local/share",
              ["project"] = os.getenv("HOME") .. "/newegg",
              ["wiki"] = os.getenv("HOME") .. "/wiki",
            },
          },
        },
      })
    end,
  },

  -- easily jump to any location and enhanced f/t motions for Leap
  {
    "ggandor/flit.nvim",
    keys = function()
      ---@type LazyKeys[]
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
  },
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },

  -- references
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = { delay = 200 },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "<M-[>",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            vim.cmd.cprev({ mods = { emsg_silent = true } })
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "<M-]>",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            vim.cmd.cnext({ mods = { emsg_silent = true } })
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
        { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
        { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
        { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
        { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
        { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
        { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    },
  },

  -- marks
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      default_mappings = true,
    },
  },
}
