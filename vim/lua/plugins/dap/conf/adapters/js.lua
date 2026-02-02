local dap = require("dap")
local M = {}

M.setup = function()
    -- Using the dap-vscode-js plugin for JavaScript debugging
    local ok, dap_vscode_js = pcall(require, "dap-vscode-js")
    if ok then
        dap_vscode_js.setup({
            node_path = "node",
            debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",                -- Path to debugger installation (if using Mason)
            debugger_cmd = { "js-debug-adapter" },                                                       -- Command to use (if not using Mason)
            adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register
            -- log_file_path = "(stdpath cache)/dap_vscode_js.log", -- Path for outputting debug adapter logs
            -- log_file_level = vim.log.levels["INFO"], -- Debug adapter log level
        })
    else
        -- Fallback to manual configuration if dap-vscode-js is not available
        for _, name in ipairs({ "node", "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }) do
            dap.adapters[name] = {
                type = "server",
                host = "127.0.0.1",
                port = "${port}",
            }
        end
    end

    -- Define configurations for JavaScript/TypeScript
    for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        require("dap").configurations[language] = {
            {
                name = "Launch file",
                type = "pwa-node",
                request = "launch",
                program = "${file}",
                cwd = "${workspaceFolder}",
            },
            {
                name = "Attach to process",
                type = "pwa-node",
                request = "attach",
                processId = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
            },
        }
    end
end

return M
