local util = require('util')
local utilLsp = require('util.lsp')

return {
    -- file tree

    {
        'echasnovski/mini.files',
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        version = '*',
        opts = {
            -- Customization of shown content
            content = {
                -- Predicate for which file system entries to show
                filter = function(fs_entry)
                    return not vim.startswith(fs_entry.name, '.')
                end,
                -- What prefix to show to the left of file system entry
                prefix = nil,
                -- In which order to show file system entries
                sort = nil,
            },

            -- Module mappings created only inside explorer.
            -- Use `''` (empty string) to not create one.
            mappings = {
                close       = 'q',
                go_in       = 'l',
                go_in_plus  = '<CR>',
                go_out      = 'h',
                go_out_plus = '<BS>',
                reset       = '<ESC>',
                reveal_cwd  = '@',
                show_help   = '?',
                synchronize = '=',
                trim_left   = '<',
                trim_right  = '>',
            },

            -- General options
            options = {
                -- Whether to delete permanently or move into module-specific trash
                permanent_delete = true,
                -- Whether to use for editing directories
                use_as_default_explorer = true,
            },

            -- Customization of explorer windows
            windows = {
                -- Maximum number of windows to show side by side
                max_number = math.huge,
                -- Whether to show preview of file/directory under cursor
                preview = true,
                -- Width of focused window
                width_focus = 30,
                -- Width of non-focused window
                width_nofocus = 30,
                -- Width of preview window
                width_preview = 80,
            },
        },
        keys = {
            {
                "<space>f",
                function()
                    require("mini.files").open(vim.api.nvim_buf_get_name(0), false)
                end,
                desc = "Explorer focus current file",
            },
            {
                "<space>e",
                function()
                    require("mini.files").open()
                end,
                desc = "Explorer",
            },
        },

        init = function()
            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesWindowOpen',
                callback = function(args)
                    local win_id = args.data.win_id

                    -- Customize window-local settings
                    vim.wo[win_id].winblend = 0
                    vim.api.nvim_win_set_config(win_id,
                        {
                            border = { "╔", "-", "╗", "|", "╝", "-", "╚", "|" }
                        }
                    )
                end,
            })

            local show_dotfiles = false
            local filter_show = function(fs_entry) return true end
            local filter_hide = function(fs_entry)
                return not vim.startswith(fs_entry.name, '.')
            end

            local toggle_dotfiles = function()
                show_dotfiles = not show_dotfiles
                local new_filter = show_dotfiles and filter_show or filter_hide
                MiniFiles.refresh({ content = { filter = new_filter } })
            end

            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesBufferCreate',
                callback = function(args)
                    local buf_id = args.data.buf_id
                    -- Tweak left-hand side of mapping to your liking
                    vim.keymap.set('n', '.', toggle_dotfiles, { buffer = buf_id })
                end,
            })


            local map_split = function(buf_id, lhs, direction)
                local rhs = function()
                    -- Make new window and set it as target
                    local new_target_window
                    vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
                        vim.cmd(direction .. ' split')
                        new_target_window = vim.api.nvim_get_current_win()
                    end)

                    MiniFiles.set_target_window(new_target_window)
                    MiniFiles.go_in({ close_on_file = false })
                end

                -- Adding `desc` will result into `show_help` entries
                local desc = 'Split ' .. direction
                vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
            end

            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesBufferCreate',
                callback = function(args)
                    local buf_id = args.data.buf_id
                    map_split(buf_id, '-', 'belowright horizontal')
                    map_split(buf_id, '|', 'belowright vertical')
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesActionRename",
                callback = function(event)
                    utilLsp.on_rename(event.data.from, event.data.to)
                end,
            })
        end,
    },
    -- {
    --     "nvim-tree/nvim-tree.lua",
    --     dependencies = {
    --         "nvim-tree/nvim-web-devicons",
    --     },
    --     opts = {
    --         sort_by = "case_sensitive",
    --         select_prompts = true,
    --         disable_netrw = true,
    --         reload_on_bufenter = true,
    --         view = {
    --             width = 50,
    --         },
    --         renderer = {
    --             group_empty = true,
    --         },
    --         filters = {
    --             dotfiles = true,
    --         },
    --         on_attach = function(bufnr)
    --             local api = require("nvim-tree.api")

    --             local function opts(desc)
    --                 return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    --             end

    --             api.config.mappings.default_on_attach(bufnr)

    --             vim.keymap.del("n", "g?", { buffer = bufnr })
    --             vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
    --         end,
    --     },

    --     keys = {
    --         {
    --             "<space>f",
    --             function()
    --                 require("nvim-tree.api").tree.open({ find_file = true })
    --             end,
    --             desc = "Explorer focus current file",
    --         },
    --         {
    --             "<space>e",
    --             function()
    --                 require("nvim-tree.api").tree.toggle()
    --             end,
    --             desc = "Explorer",
    --         },
    --     },

    --     init = function()
    --         if vim.fn.argc() == 1 then
    --             local stat = vim.loop.fs_stat(vim.fn.argv(0))
    --             if stat and stat.type == "directory" then
    --                 require("nvim-tree")
    --             end
    --         end
    --     end,
    -- },

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
            { "<leader>sw", function() require("spectre").open() end,                                   desc = "Replace in files (Spectre)" },
            { "<leader>sf", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Replace in current file(Spectre)" },
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
            { "<leader>sm", "<cmd>Telescope marks<cr>",       desc = "Jump to Mark" },
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
                        { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
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
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },

}
