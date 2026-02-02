return {
    {
        'hrsh7th/nvim-cmp',
        event = "InsertEnter",
        dependencies = {
            {
                'hrsh7th/cmp-nvim-lsp',
            },
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',

            -- autocomplete snip source
            'saadparwaiz1/cmp_luasnip',
            {
                'L3MON4D3/LuaSnip',
                dependencies = { "rafamadriz/friendly-snippets" },
                opts = {
                    history = true,
                    delete_check_events = "TextChanged",
                },
                config = function(_, opts)
                    require("luasnip").setup(opts)
                    require("luasnip.loaders.from_vscode").lazy_load()
                end
            },

            -- extend sources
            'hrsh7th/cmp-nvim-lsp-signature-help',

            -- spell
            'f3fora/cmp-spell',
            -- dap
            "rcarriga/cmp-dap",
        },
        opts = function()
            return require("plugins.cmp.conf").defaults()
        end,
        config = function(_, opts)
            require("plugins.cmp.conf").setup(opts)
            require("plugins.cmp.conf").initialize()
        end,
    },
}
