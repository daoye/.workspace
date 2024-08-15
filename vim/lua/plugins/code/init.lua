return {
    {
        "williamboman/mason.nvim",
        config = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = true,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
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
        init = function() end,
        config = function(_, opts)
            require("conf.lsp").setup(opts)
        end,
    },

    -- formater, lints
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.prettierd,
                    null_ls.builtins.code_actions.refactoring,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.completion.spell,
                },
            })
        end,
    },

    -- formater
    -- {
    --     "stevearc/conform.nvim",
    --     dependencies = { "mason.nvim" },
    --     lazy = true,
    --     cmd = "ConformInfo",
    --     opts = {
    --         default_format_opts = {
    --             timeout_ms = 3000,
    --             async = false,
    --             quiet = false,
    --             lsp_format = "fallback",
    --         },
    --         formatters_by_ft = {
    --             python = { "isort", "black" },
    --             cs = { "csharpier" },
    --             lua = { "stylua" },
    --             javascript = { "prettierd", "prettier" },
    --             typescript = { "prettierd", "prettier" },
    --             javascriptreact = { "prettierd", "prettier" },
    --             typescriptreact = { "prettierd", "prettier" },
    --             json = { { "prettierd", "prettier" } },
    --             markdown = { "prettierd", "prettier" },
    --             html = { "htmlbeautifier" },
    --             bash = { "beautysh" },
    --             proto = { "buf" },
    --             rust = { "rustfmt" },
    --             yaml = { "yamlfix" },
    --             toml = { "taplo" },
    --             css = { "prettierd", "prettier" },
    --             scss = { "prettierd", "prettier" },
    --         },
    --         formatters = {
    --             injected = { options = { ignore_errors = true } },
    --         },
    --     },
    -- },

    -- -- linter
    -- {
    --     "mfussenegger/nvim-lint",
    --     opts = {
    --         events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    --         linters_by_ft = {
    --             typescript = { "eslint_d" },
    --             typescriptreact = { "eslint_d" },
    --             javascript = { "eslint_d" },
    --             javascriptreact = { "eslint_d" },
    --             -- Use the "*" filetype to run linters on all filetypes.
    --             -- ['*'] = { 'global linter' },
    --             -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
    --             -- ['_'] = { 'fallback linter' },
    --             -- ["*"] = { "typos" },
    --         },
    --         ---@type table<string,table>
    --         linters = {
    --             -- -- Example of using selene only when a selene.toml file is present
    --             -- selene = {
    --             --   -- `condition` is another LazyVim extension that allows you to
    --             --   -- dynamically enable/disable linters based on the context.
    --             --   condition = function(ctx)
    --             --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
    --             --   end,
    --             -- },
    --         },
    --     },
    --     config = function(_, opts)
    --         local M = {}

    --         local lint = require("lint")
    --         for name, linter in pairs(opts.linters) do
    --             if type(linter) == "table" and type(lint.linters[name]) == "table" then
    --                 lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
    --                 if type(linter.prepend_args) == "table" then
    --                     lint.linters[name].args = lint.linters[name].args or {}
    --                     vim.list_extend(lint.linters[name].args, linter.prepend_args)
    --                 end
    --             else
    --                 lint.linters[name] = linter
    --             end
    --         end
    --         lint.linters_by_ft = opts.linters_by_ft

    --         function M.debounce(ms, fn)
    --             local timer = vim.uv.new_timer()
    --             return function(...)
    --                 local argv = { ... }
    --                 timer:start(ms, 0, function()
    --                     timer:stop()
    --                     vim.schedule_wrap(fn)(unpack(argv))
    --                 end)
    --             end
    --         end

    --         function M.lint()
    --             -- Use nvim-lint's logic first:
    --             -- * checks if linters exist for the full filetype first
    --             -- * otherwise will split filetype by "." and add all those linters
    --             -- * this differs from conform.nvim which only uses the first filetype that has a formatter
    --             local names = lint._resolve_linter_by_ft(vim.bo.filetype)

    --             -- Create a copy of the names table to avoid modifying the original.
    --             names = vim.list_extend({}, names)

    --             -- Add fallback linters.
    --             if #names == 0 then
    --                 vim.list_extend(names, lint.linters_by_ft["_"] or {})
    --             end

    --             -- Add global linters.
    --             vim.list_extend(names, lint.linters_by_ft["*"] or {})

    --             -- Filter out linters that don't exist or don't match the condition.
    --             local ctx = { filename = vim.api.nvim_buf_get_name(0) }
    --             ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
    --             names = vim.tbl_filter(function(name)
    --                 local linter = lint.linters[name]
    --                 if not linter then
    --                     vim.notify("Linter not found: " .. name, vim.log.levels.WARN)
    --                 end
    --                 return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
    --             end, names)

    --             -- Run linters.
    --             if #names > 0 then
    --                 lint.try_lint(names)
    --             end
    --         end

    --         vim.api.nvim_create_autocmd(opts.events, {
    --             group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    --             callback = M.debounce(100, M.lint),
    --         })
    --     end,
    -- },

    -- csharp
    {
        "Decodetalkers/csharpls-extended-lsp.nvim",
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
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

    -- fold
    {
        "kevinhwang91/nvim-ufo",
        -- enabled = false,
        dependencies = {
            "kevinhwang91/promise-async",
            "neovim/nvim-lspconfig",
        },
        event = { "VeryLazy" },
        opts = {
            default = {
                close_fold_kinds_for_ft = { "imports", "comment" },
            },
        },
        keys = {
            {
                "zR",
                function()
                    require("ufo").openAllFolds()
                end,
                desc = "Open all folds",
                mode = { "n" },
            },
            {
                "zM",
                function()
                    require("ufo").closeAllFolds()
                end,
                desc = "Close all folds",
                mode = { "n" },
            },
            {
                "zr",
                function()
                    require("ufo").openFoldsExceptKinds()
                end,
                desc = "Open folds",
                mode = { "n" },
            },
            {
                "zM",
                function()
                    require("ufo").closeFoldsWith()
                end,
                desc = "Close folds",
                mode = { "n" },
            },
        },
    },
}
