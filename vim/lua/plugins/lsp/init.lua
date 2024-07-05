return {
    {
        "williamboman/mason.nvim",
        config = true
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        }
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- for coq auto completion
            { "ms-jpq/coq_nvim",       branch = "coq" },
            { "ms-jpq/coq.artifacts",  branch = "artifacts" },
            { 'ms-jpq/coq.thirdparty', branch = "3p" }
        },
        init = function()
            vim.g.coq_settings = {
                auto_start = true,
                limits = {
                    completion_auto_timeout = 0,
                },
                completion = {
                    always = true,
                    skip_after = { "{", "}", "[", "]", " ", ":" },
                    smart = true,
                },
                keymap = {
                    recommended = true,
                    pre_select = true,
                },
            }
        end,
        config = function(_, opts)
            require("lsp").setup(opts)
        end
    },
    -- csharp
    {
        "Decodetalkers/csharpls-extended-lsp.nvim"
    },

    -- nvim lua
    { "folke/neodev.nvim", opts = {} },
}
