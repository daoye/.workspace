-- AI Plugin Configuration
-- Supports both opencode.nvim and codecompanion.nvim
-- Switch via vim.g.ai_provider = "opencode" | "codecompanion"
-- Default: "opencode"

-- Set default AI provider
vim.g.ai_provider = vim.g.ai_provider or "opencode"

local function is_opencode()
    return vim.g.ai_provider == "opencode"
end

local function is_codecompanion()
    return vim.g.ai_provider == "codecompanion"
end

return {
    -- OpenCode.nvim (default)
    {
        "NickvanDyke/opencode.nvim",
        cond = is_opencode,
        dependencies = {
            {
                "folke/snacks.nvim",
                opts = {
                    input = {},
                    picker = {},
                    terminal = {},
                },
            },
        },
        config = function()
            require("plugins.ai.conf.opencode").setup()
        end,
        keys = {
            -- Toggle
            {
                "<leader>aa",
                function()
                    require("opencode").toggle()
                end,
                mode = { "n", "t" },
                desc = "AI: Toggle OpenCode",
            },

            -- Ask with context
            {
                "<leader>ai",
                function()
                    require("opencode").ask("@this: ", { submit = false })
                end,
                mode = { "n", "x" },
                desc = "AI: Ask OpenCode",
            },

            -- Ask and submit immediately
            {
                "<leader>aI",
                function()
                    require("opencode").ask("@this: ", { submit = true })
                end,
                mode = { "n", "x" },
                desc = "AI: Ask OpenCode (submit)",
            },

            -- Select action
            {
                "<leader>ap",
                function()
                    require("opencode").select()
                end,
                mode = { "n", "x" },
                desc = "AI: Actions Palette",
            },

            -- Quick prompts
            {
                "<leader>ae",
                function()
                    require("opencode").prompt("explain")
                end,
                mode = { "n", "x" },
                desc = "AI: Explain Code",
            },
            {
                "<leader>af",
                function()
                    require("opencode").prompt("fix")
                end,
                mode = { "n", "x" },
                desc = "AI: Fix Code",
            },
            {
                "<leader>ar",
                function()
                    require("opencode").prompt("review")
                end,
                mode = { "n", "x" },
                desc = "AI: Review Code",
            },
            {
                "<leader>at",
                function()
                    require("opencode").prompt("test")
                end,
                mode = { "n", "x" },
                desc = "AI: Generate Tests",
            },
            {
                "<leader>ad",
                function()
                    require("opencode").prompt("document")
                end,
                mode = { "n", "x" },
                desc = "AI: Generate Docs",
            },
            {
                "<leader>ao",
                function()
                    require("opencode").prompt("optimize")
                end,
                mode = { "n", "x" },
                desc = "AI: Optimize Code",
            },

            -- Diff review
            {
                "<leader>am",
                function()
                    require("opencode").prompt("diff")
                end,
                mode = "n",
                desc = "AI: Review Git Diff",
            },

            -- Operator for ranges (supports dot-repeat)
            {
                "go",
                function()
                    return require("opencode").operator("@this ")
                end,
                mode = { "n", "x" },
                desc = "AI: Add range to OpenCode",
                expr = true,
            },
            {
                "goo",
                function()
                    return require("opencode").operator("@this ") .. "_"
                end,
                mode = "n",
                desc = "AI: Add line to OpenCode",
                expr = true,
            },

            -- Session controls
            {
                "<leader>ac",
                function()
                    require("opencode").command("session.new")
                end,
                mode = "n",
                desc = "AI: New Session",
            },
            {
                "<leader>al",
                function()
                    require("opencode").command("session.list")
                end,
                mode = "n",
                desc = "AI: List Sessions",
            },
            {
                "<leader>as",
                function()
                    require("opencode").command("session.select")
                end,
                mode = "n",
                desc = "AI: Select Session",
            },
        },
    },

    -- CodeCompanion.nvim (alternative)
    {
        "olimorris/codecompanion.nvim",
        cond = is_codecompanion,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
            {
                "zbirenbaum/copilot.lua",
                config = true,
            },
        },
        opts = function()
            return require("plugins.ai.conf.codecompanion").opts()
        end,
        config = function(_, opts)
            require("plugins.ai.conf.codecompanion").setup(opts)
        end,
        keys = {
            -- Chat
            { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI: Toggle Chat" },
            { "<leader>ac", "<cmd>CodeCompanionChat<cr>",        mode = { "n", "v" }, desc = "AI: New Chat" },
            { "<leader>aA", "<cmd>CodeCompanionChat Add<cr>",    mode = "v",          desc = "AI: Add to Chat" },

            -- Actions
            { "<leader>ap", "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "AI: Actions Palette" },

            -- Inline
            { "<leader>ai", "<cmd>CodeCompanion<cr>",            mode = { "n", "v" }, desc = "AI: Inline Prompt" },

            -- Quick prompts
            { "<leader>ae", "<cmd>CodeCompanion /explain<cr>",   mode = "v",          desc = "AI: Explain Code" },
            { "<leader>af", "<cmd>CodeCompanion /fix<cr>",       mode = "v",          desc = "AI: Fix Code" },
            { "<leader>ar", "<cmd>CodeCompanion /refactor<cr>",  mode = "v",          desc = "AI: Refactor Code" },
            { "<leader>at", "<cmd>CodeCompanion /tests<cr>",     mode = "v",          desc = "AI: Generate Tests" },
            { "<leader>ad", "<cmd>CodeCompanion /doc<cr>",       mode = "v",          desc = "AI: Generate Docs" },
            { "<leader>ao", "<cmd>CodeCompanion /optimize<cr>",  mode = "v",          desc = "AI: Optimize Code" },

            -- Commit
            { "<leader>am", "<cmd>CodeCompanion /commit<cr>",    mode = "n",          desc = "AI: Generate Commit Message" },
        },
    },
}