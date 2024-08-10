return {
    -- autocomplete
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',

            -- autocomplete snip source
            'saadparwaiz1/cmp_luasnip',
            {
                'L3MON4D3/LuaSnip',
                dependencies = { "rafamadriz/friendly-snippets" },
                init = function()
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
        config = function(_, opts)
            require("conf.autocomplete").setup(opts)
        end,
        init = function()
            require("conf.autocomplete").initialize()
        end
    },
}
