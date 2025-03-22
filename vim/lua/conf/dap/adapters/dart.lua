local dap = require("dap")
local dap_ext = require("dap.ext.vscode")
local utils = require("conf.dap.utils")
local M = {}

local find_flutter = function()
    local command = vim.fn.exepath('flutter')

    if vim.fn.executable(command) == 1 then
        return command
    else
        return '/usr/bin/flutter'
    end
end

local find_dart = function()
    local command = vim.fn.exepath('dart')

    if vim.fn.executable(command) == 1 then
        return command
    else
        return '/usr/bin/dart'
    end
end


M.setup = function()
    dap.adapters.dart = {
        type = 'executable',
        command = 'dart',
        args = { 'debug_adapter' },
        -- windows users will need to set 'detached' to false
        options = {
            detached = false,
        }
    }
    dap.adapters.flutter = {
        type = 'executable',
        command = 'flutter',
        args = { 'debug_adapter' },
        -- windows users will need to set 'detached' to false
        options = {
            detached = false,
        }
    }

    local dart_path = find_dart()
    local flutter_path = find_flutter()

    local configurations = {
        {
            type = "dart",
            request = "launch",
            name = "Launch dart",
            dartSdkPath = dart_path,
            flutterSdkPath = flutter_path,
            program = "${workspaceFolder}/lib/main.dart",
            cwd = "${workspaceFolder}",
        },
        {
            type = "flutter",
            request = "launch",
            name = "Launch flutter",
            dartSdkPath = dart_path,
            flutterSdkPath = flutter_path,
            program = "${workspaceFolder}/lib/main.dart",
            cwd = "${workspaceFolder}",
        }
    }

    local vscode_configs = dap_ext.getconfigs(utils.get_vscode_cfg_path())

    local name = 'dart'
    dap.configurations[name] = dap.configurations[name] or {}

    for _, cfg in ipairs(configurations) do
        local exists = false

        if vscode_configs then
            for _, v in ipairs(vscode_configs) do
                if v['type'] == 'dart' and v['name'] == cfg['name'] then
                    exists = true
                end
                if v['type'] == 'flutter' and v['name'] == cfg['name'] then
                    exists = true
                end
            end
        end

        if not exists then
            table.insert(dap.configurations[name], cfg)
        end
    end
end

M.vscode = function()
    local need = vim.bo.filetype == "dart"
    if not need then
        return
    end

    local dart_path = find_dart()
    local flutter_path = find_flutter()

    local configurations = {
        {
            type = "dart",
            request = "launch",
            name = "Launch dart",
            dartSdkPath = dart_path,
            flutterSdkPath = flutter_path,
            program = "${workspaceFolder}/lib/main.dart",
            cwd = "${workspaceFolder}",
        },
        {
            type = "flutter",
            request = "launch",
            name = "Launch flutter",
            dartSdkPath = dart_path,
            flutterSdkPath = flutter_path,
            program = "${workspaceFolder}/lib/main.dart",
            cwd = "${workspaceFolder}",
        }
    }

    utils.save_launch_json(configurations)
end

return M
