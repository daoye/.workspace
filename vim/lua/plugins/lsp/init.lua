return {
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonUpdate" },
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        },
        config = function(_, opts)
            require("mason").setup(opts)
            vim.api.nvim_create_user_command("MasonUpdate", function()
                vim.cmd.MasonUpdate()
            end, {})
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            ensure_installed = {
                "lua_ls",
                "omnisharp", -- Correct name for C# language server
                "ts_ls",
                "vuels",     -- For Vue.js support (correct name for volar)
                "pyright",
                "clangd",
                "rust_analyzer",
                "html",
                "cssls",
                "dockerls", -- For Docker support
            },
            automatic_installation = { exclude = {} },
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        opts = {
            -- add any global capabilities here
            capabilities = {
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    },
                },
            },
        },
        config = function(_, opts)
            require("plugins.lsp.conf").setup(opts)
        end,
    },
    -- formater, lints
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            ensure_installed = { "stylua", "prettierd", "black" },
            automatic_installation = {
                exclude = {},
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
            local null_ls = require("null-ls")

            return {
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.prettierd,
                    null_ls.builtins.formatting.black,

                    null_ls.builtins.code_actions.refactoring,

                    -- null_ls.builtins.completion.spell,
                },
            }
        end,
    },

    -- csharp
    {
        "Decodetalkers/csharpls-extended-lsp.nvim",
    },

    -- typescript
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },


    -- lua
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "Bilal2453/luvit-meta",
        lazy = true
    }, -- optional `vim.uv` typings

}
