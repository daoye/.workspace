local dap = require("dap")
local M = {}

M.setup = function()
    -- HTML/CSS debugging usually goes through browser debugging
    -- We'll use the existing js-debug adapter for this
    dap.configurations.html = {
        {
            name = "Debug with Chrome",
            type = "pwa-chrome",
            request = "launch",
            url = function()
                local path = vim.fn.input('URL: ', 'http://localhost:3000/', 'file')
                return path
            end,
            webRoot = "${workspaceFolder}",
        },
        {
            name = "Debug with Edge",
            type = "pwa-msedge",
            request = "launch",
            url = function()
                local path = vim.fn.input('URL: ', 'http://localhost:3000/', 'file')
                return path
            end,
            webRoot = "${workspaceFolder}",
        },
    }

    dap.configurations.css = {
        {
            name = "Debug with Chrome",
            type = "pwa-chrome",
            request = "launch",
            url = function()
                local path = vim.fn.input('URL: ', 'http://localhost:3000/', 'file')
                return path
            end,
            webRoot = "${workspaceFolder}",
        },
        {
            name = "Debug with Edge",
            type = "pwa-msedge",
            request = "launch",
            url = function()
                local path = vim.fn.input('URL: ', 'http://localhost:3000/', 'file')
                return path
            end,
            webRoot = "${workspaceFolder}",
        },
    }
end

return M
