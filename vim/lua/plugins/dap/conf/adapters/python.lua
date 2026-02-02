local dap = require("dap")
local M = {}

M.setup = function()
    dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
    }

    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            python = "/usr/bin/python3",
            cwd = "${workspaceFolder}",
        },
        {
            type = "python",
            request = "launch",
            name = "Debug pytest",
            module = "pytest",
            cwd = "${workspaceFolder}",
            args = { "-v" },
            python = "/usr/bin/python3",
            console = "integratedTerminal",
        },
    }
end

return M
