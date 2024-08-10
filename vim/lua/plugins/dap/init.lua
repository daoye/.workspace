return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
        },
        -- event = { "VeryLazy" },
        opts = {},
        keys = {
            { "<F5>",       function() require("dap").continue() end,                                                    desc = "Continue with picked configuration" },
            { "<S-F5>",     function() require("dap").terminate() end,                                                   desc = "Terminate" },
            { "<C-F5>",     function() require("dap").restart() end,                                                     desc = "Restart" },
            { "<A-F5>",     function() require("dap").continue() end,                                                    desc = "Continue" },
            { "<F6>",       function() require("dap").run_to_cursor() end,                                               desc = "Run to Cursor" },
            { "<F9>",       function() require("dap").toggle_breakpoint() end,                                           desc = "Toggle Breakpoint" },
            { "<C-F9>",     function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,        desc = "Breakpoint with condition" },
            { "<S-F9>",     function() require("dap").clear_breakpoints() end,                                           desc = "Clear breakpoints" },
            { "<A-F9>",     function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = "Breakpoint with log" },
            { "<F10>",      function() require("dap").step_over() end,                                                   desc = "Step Over" },
            { "<S-F10>",    function() require("dap").step_out() end,                                                    desc = "Step Out" },
            { "<F11>",      function() require("dap").step_into() end,                                                   desc = "Step Into" },
            { "<F1>",       function() require("dap.repl").toggle({ height = 10 }) end,                                  desc = "Toggle repl buffer" },
            { "<leader>dg", function() require("dap").goto_() end,                                                       desc = "Go to line (no execute)" },
            { "<leader>dj", function() require("dap").down() end,                                                        desc = "Down" },
            { "<leader>dk", function() require("dap").up() end,                                                          desc = "Up" },
            { "<leader>dl", function() require("dap").run_last() end,                                                    desc = "Run Last" },
            { "<leader>dp", function() require("dap").pause() end,                                                       desc = "Pause" },
            { "<leader>ds", function() require("dap").session() end,                                                     desc = "Session" },
        },
        config = function()
            require("conf.dap").setup()
        end,
    },
    {

        "nvim-telescope/telescope-dap.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require('telescope').load_extension('dap')
        end,
        keys = {
            { "<leader>dc", function() require 'telescope'.extensions.dap.commands {} end,         desc = "Dap commands" },
            { "<leader>do", function() require 'telescope'.extensions.dap.configurations {} end,   desc = "Dap configurations" },
            { "<leader>db", function() require 'telescope'.extensions.dap.list_breakpoints {} end, desc = "Dap list breakpoints" },
            { "<leader>dv", function() require 'telescope'.extensions.dap.variables {} end,        desc = "Dap variables" },
            { "<leader>df", function() require 'telescope'.extensions.dap.frames {} end,           desc = "Dap frames" },
        },
    }
}
