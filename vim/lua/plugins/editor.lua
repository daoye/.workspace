local util = require('util')
local utilLsp = require('util.lsp')
local utilMinifile = require('util.minifile')

return {
    -- file explorer
    {
        'stevearc/oil.nvim',
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            keymaps = {
                ["?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-v>"] = "actions.select_vsplit",
                ["<C-h>"] = "actions.select_split",
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["q"] = "actions.close",
                ["<Leader>r"] = "actions.refresh",
                ["<BS>"] = "actions.parent",
                ["<ESC>"] = "actions.open_cwd",
                ["cd"] = "actions.cd",
                ["~"] = "actions.tcd",
                ["<Leader>s"] = "actions.change_sort",
                ["<Leader><Leader>"] = "actions.open_external",
                ["<Leader>."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },
            -- Set to false to disable all of the above keymaps
            use_default_keymaps = false,

            -- watch file system and auto reload
            experimental_watch_for_changes = true,
        },
        keys = {
            {
                "<space>f",
                function()
                    -- require("oil").open(vim.api.nvim_buf_get_name(0), false)
                    require("oil").open()
                end,
                desc = "Explorer focus current file",
            },
            {
                "<space>e",
                function()
                    require("oil").open(vim.loop.cwd())
                end,
                desc = "Explorer",
            },
        },
    },
    -- search/replace in multiple files
    {
        "nvim-pack/nvim-spectre",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
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
            {
                "<leader>sw",
                function() require("spectre").open() end,
                desc =
                "Replace in files (Spectre)"
            },
            {
                "<leader>sf",
                function() require("spectre").open_file_search({ select_word = true }) end,
                desc =
                "Replace in current file(Spectre)"
            },
        },
    },

    -- fzf file search
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
            { "<leader>fg",      util.telescope("live_grep"),                          desc = "Grep (root dir)" },
            { "<leader>fG",      util.telescope("live_grep", { cwd = false }),         desc = "Grep (cwd)" },
            { "<leader>:",       "<cmd>Telescope command_history<cr>",                 desc = "Command History" },
            { "<leader><space>", util.telescope("files"),                              desc = "Find Files (root dir)" },
            -- find
            { "<leader>fb",      "<cmd>Telescope buffers<cr>",                         desc = "Buffers" },
            { "<leader>ff",      util.telescope("files"),                              desc = "Find Files (root dir)" },
            { "<leader>fF",      util.telescope("find_files"),                         desc = "Find All Files (root dir)" },
            { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",                        desc = "Recent" },
            { "<leader>fR",      util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
            { "<leader>fk",      "<cmd>Telescope keymaps<cr>",                         desc = "Keymaps" },
            { "<leader>f?",      "<cmd>Telescope help_tags<cr>",                       desc = "Help" },
            { "<leader>fw",      util.telescope("grep_string"),                        desc = "Word (root dir)" },
            { "<leader>fW",      util.telescope("grep_string", { cwd = false }),       desc = "Word (cwd)" },
            -- git
            { "<leader>gc",      "<cmd>Telescope git_commits<CR>",                     desc = "commits" },
            { "<leader>gs",      "<cmd>Telescope git_status<CR>",                      desc = "status" },
            -- search
            { "<leader>sa",      "<cmd>Telescope autocommands<cr>",                    desc = "Auto Commands" },
            -- { "<leader>sb",      "<cmd>Telescope current_buffer_fuzzy_find<cr>",            desc = "Buffer" },
            { "<leader>sc",      "<cmd>Telescope command_history<cr>",                 desc = "Command History" },
            { "<leader>sC",      "<cmd>Telescope commands<cr>",                        desc = "Commands" },
            { "<leader>sd",      "<cmd>Telescope diagnostics bufnr=0<cr>",             desc = "Document diagnostics" },
            { "<leader>sD",      "<cmd>Telescope diagnostics<cr>",                     desc = "Workspace diagnostics" },
            { "<leader>sh",      "<cmd>Telescope help_tags<cr>",                       desc = "Help Pages" },
            {
                "<leader>sH",
                "<cmd>Telescope highlights<cr>",
                desc = "Search Highlight Groups",
            },
            { "<leader>sk", "<cmd>Telescope keymaps<cr>",     desc = "Key Maps" },
            { "<leader>sM", "<cmd>Telescope man_pages<cr>",   desc = "Man Pages" },
            { "<leader>fm", "<cmd>Telescope marks<cr>",       desc = "Jump to Mark" },
            { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
            { "<leader>sR", "<cmd>Telescope resume<cr>",      desc = "Resume" },
            {
                "<leader>uC",
                util.telescope("colorscheme", { enable_preview = true }),
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
                util.telescope("lsp_document_symbols", {
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
                util.telescope("lsp_dynamic_workspace_symbols", {
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
                                util.telescope("find_files", { no_ignore = true })()
                            end,
                            ["<a-h>"] = function()
                                util.telescope("find_files", { hidden = true })()
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
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
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


    -- theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                notify = true,
                noice = true,
                mini = true,
                barbar = true,
                mason = true,
                mini = true,
                treesitter_context = true,
                leap = true,
            },
        },
    },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            local icons = require("conf").icons
            local Util = require("util")

            return {
                options = {
                    theme = "auto",
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "dashboard", "alpha" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                        { "filetype", icon_only = false, separator = "", padding = { left = 1, right = 0 } },
                        { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
                        -- stylua: ignore
                        {
                            function() return require("nvim-navic").get_location() end,
                            cond = function()
                                return package.loaded["nvim-navic"] and
                                    require("nvim-navic").is_available()
                            end,
                        },
                    },
                    lualine_x = {
                        -- stylua: ignore
                        {
                            function() return require("noice").api.status.command.get() end,
                            cond = function()
                                return package.loaded["noice"] and
                                    require("noice").api.status.command.has()
                            end,
                            color = Util.fg("Statement"),
                        },
                        -- stylua: ignore
                        {
                            function() return require("noice").api.status.mode.get() end,
                            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                            color = Util.fg("Constant"),
                        },
                        -- stylua: ignore
                        {
                            function() return "  " .. require("dap").status() end,
                            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
                            color = Util.fg("Debug"),
                        },
                        {
                            require("lazy.status").updates,
                            cond = require("lazy.status").has_updates,
                            color = Util.fg("Special")
                        },
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                        },
                    },
                    lualine_y = {
                        { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        function()
                            return " " .. os.date("%R")
                        end,
                    },
                },
                extensions = { "neo-tree", "lazy" },
            }
        end,
    },

    -- lsp symbol navigation for lualine
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        init = function()
            vim.g.navic_silence = true
            require("util").on_attach(function(client, buffer)
                if client.server_capabilities.documentSymbolProvider then
                    require("nvim-navic").attach(client, buffer)
                end
            end)
        end,
        opts = function()
            return {
                separator = " ",
                highlight = true,
                depth_limit = 5,
                icons = require("conf").icons.kinds,
            }
        end,
    },

    -- better vim.ui
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

    -- movation
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            {
                "S",
                mode = { "n", "x", "o" },
                function() require("flash").treesitter() end,
                desc =
                "Flash Treesitter"
            },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc =
                "Remote Flash"
            },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc =
                "Treesitter Search"
            },
            {
                "<c-s>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc =
                "Toggle Flash Search"
            },
        },
    },

}
