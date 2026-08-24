local utils = require("conf.utils")

local adapter_js = require("plugins.dap.conf.adapters.js")
local adapter_cs = require("plugins.dap.conf.adapters.cs")
local adapter_cpp = require("plugins.dap.conf.adapters.cpp")
local adapter_python = require("plugins.dap.conf.adapters.python")
local adapter_dart = require("plugins.dap.conf.adapters.dart")

local M = {}


M.setup = function()
    local dap = require("dap")

    dap.set_log_level("TRACE")

    dap.listeners.after.event_initialized["aprilzz"] = function(session)
        dap.repl.open({ height = 10 }, "belowright split")
    end


    dap.listeners.on_config["aprilzz"] = function(config)
        local cfg = vim.fn.deepcopy(config)

        local task = cfg["preLaunchTask"]
        if task then
            require("conf.utils").run_command(string.gsub(task, '${workspaceFolder}', vim.fn.getcwd()))
        end
        return config
    end

    -- dap signs
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    local kind = {
        Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = " ",
        -- Breakpoint = "󰠭 ",
        BreakpointCondition = " ",
        BreakpointRejected = { " ", "DiagnosticError" },
        LogPoint = ".>",
    }

    for name, sign in pairs(kind) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
            "Dap" .. name,
            { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
    end

    -- adapters
    adapter_js.setup()
    adapter_cs.setup()
    adapter_cpp.setup()
    adapter_python.setup()
    adapter_dart.setup()
    require("plugins.dap.conf.adapters.html").setup()
    require("plugins.dap.conf.adapters.rust").setup()
end

M.vscode = function()
    _ = adapter_js.vscode and adapter_js.vscode()
    _ = adapter_cs.vscode and adapter_cs.vscode()
    _ = adapter_cpp.vscode and adapter_cpp.vscode()
    _ = adapter_python.vscode and adapter_python.vscode()
    _ = adapter_dart.vscode and adapter_dart.vscode()

    require("plugins.dap.conf.vscode").load_config()
end

M.generate_vscode_config = function()
    require("plugins.dap.conf.vscode").generate_config()
end

M.load_vscode_config = function()
    require("plugins.dap.conf.vscode").load_config()
end

return M
