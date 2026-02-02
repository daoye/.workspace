return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
            {
                "zbirenbaum/copilot.lua",
                config = true,
            },
        },
        opts = function()
            return require("plugins.ai.conf").opts()
        end,
        config = function(_, opts)
            require("plugins.ai.conf").setup(opts)
        end,
    },
}
