local dap = require("dap")
local M = {}

M.setup = function()
    -- Using codelldb as it's more commonly available through mason
    dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
            command = 'codelldb',
            args = { "--port", "${port}" },
        },
    }

    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
    }

    -- Also add C configuration
    dap.configurations.c = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
    }
end

return M
