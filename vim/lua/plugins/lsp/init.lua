return {
    -- lspconfig
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                "folke/neoconf.nvim",
                cmd = "Neoconf",
                config = true,
            },
            {
                "folke/neodev.nvim",
                opts = {
                    experimental = {
                        pathStrict = true
                    }
                }
            },
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "hrsh7th/cmp-nvim-lsp",
                -- cond = function()
                --   return require("util").has("nvim-cmp")
                -- end,
            },
        },
        ---@class PluginLspOpts
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = false,
                update_in_insert = false,
                -- virtual_text = false,
                virtual_text = {
                    severity = vim.diagnostic.severity.ERROR,
                    spacing = 4,
                    source = "if_many",
                    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                    prefix = "icons",
                },
                severity_sort = true,
            },
            -- add any global capabilities here
            capabilities = {
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    },
                },
            },
            -- Automatically format on save
            autoformat = true,
            -- options for vim.lsp.buf.format
            -- `bufnr` and `filter` is handled by the LuaVim formatter,
            -- but can be also overridden when specified
            -- format = {
            --   formatting_options = nil,
            --   timeout_ms = nil,
            -- },
            -- LSP Server Settings
            ---@type lspconfig.options
            servers = {
                jsonls = {},
                lua_ls = {
                    -- mason = false, -- set to false if you don't want this server to be installed with mason
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
                pylsp = {
                    on_attach = function(client, buffer)
                        -- client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.hoverProvider = false
                        -- client.server_capabilities.renameProvider = false
                        client.server_capabilities.completionProvider.resolveProvider = false
                    end,
                    settings = {
                        pylsp = {
                            plugins = {
                                jedi_completion = {
                                    enabled = false,
                                },
                                pycodestyle = {
                                    enabled = false,
                                },
                                mccabe = {
                                    enabled = false,
                                },
                                pyflakes = {
                                    enabled = false,
                                },
                                pylsp_mypy = {
                                    enabled = false,
                                },
                            },
                        },
                    },
                },
                pyright = {
                    on_attach = function(client, buffer)
                        client.server_capabilities.renameProvider = false
                    end,
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "off",
                            },
                        },
                    },
                },
                csharp_ls = {
                    -- handlers = {
                    --     ["textDocument/definition"] = require('csharpls_extended').handler,
                    --     ["textDocument/typeDefinition"] = require('csharpls_extended').handler,
                    -- },
                }
            },
            -- you can do any additional lsp server setup here return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
            automatic_installation = true,
        },
        ---@param opts PluginLspOpts
        config = function(_, opts)
            local Util = require("util")
            -- setup autoformat
            require("plugins.lsp.format").autoformat = opts.autoformat
            -- setup formatting and keymaps
            Util.on_attach(function(client, buffer)
                require("plugins.lsp.format").on_attach(client, buffer)
                require("plugins.lsp.keymaps").on_attach(client, buffer)
            end)

            -- diagnostics
            for name, icon in pairs(require("conf").icons.diagnostics) do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            end

            if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
                opts.diagnostics.virtual_text.prefix = "●"
                    or function(diagnostic)
                        local icons = require("conf").icons.diagnostics
                        for d, icon in pairs(icons) do
                            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                                return icon
                            end
                        end
                    end
            end

            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            local servers = opts.servers
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities(),
                opts.capabilities or {}
            )

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            -- get all the servers that are available thourgh mason-lspconfig
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local all_mslp_servers = {}
            if have_mason then
                all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {} ---@type string[]
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            if have_mason then
                mlsp.setup({ ensure_installed = ensure_installed })
                mlsp.setup_handlers({ setup })
            end

            if Util.lsp_get_config("denols") and Util.lsp_get_config("tsserver") then
                local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
                Util.lsp_disable("tsserver", is_deno)
                Util.lsp_disable("denols", function(root_dir)
                    return not is_deno(root_dir)
                end)
            end
        end,
    },

    -- cmdline tools and lsp servers
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        opts = {
            ensure_installed = {
                "stylua",
                "shfmt",
                "flake8",
            },
        },
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },

    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
            "neovim/nvim-lspconfig",
        },
        event = { "VeryLazy" },
        opts = {
            close_fold_kinds_for_ft = { "imports", "comment" },
        },
        config = function(_, opts)
            local ftMap = {
                python = { "lsp", "treesitter" },
                -- htmldjango = { "treesitter", "indent" },
            }

            -- opts = vim.tbl_deep_extend("force", opts or {}, {
            --     provider_selector = function(bufnr, filetype, buftype)
            --         return ftMap[filetype] or { "lsp", "indent" }
            --     end,
            -- })

            require("ufo").setup()
            -- require("ufo").setup(opts)
        end,
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
