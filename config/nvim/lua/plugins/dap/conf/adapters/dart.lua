local dap = require("dap")
local dap_ext = require("dap.ext.vscode")
local utils = require("plugins.dap.conf.utils")
local device_manager = require("plugins.dap.conf.flutter.device_manager")
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

local function launch_flutter_with_device()
    -- 如果正在启动中，忽略
    if device_manager:is_busy() then
        return
    end
    
    -- 如果已有调试会话，继续执行
    if dap.session() then
        dap.continue()
        return
    end

    local dart_path = find_dart()
    local flutter_path = find_flutter()

    device_manager:set_launching(true)

    device_manager:ensure_device_selected(function(device_id)
        if not device_id then
            device_manager:set_launching(false)
            vim.notify("No device selected, aborting launch", vim.log.levels.WARN)
            return
        end

        local config = {
            type = "flutter",
            request = "launch",
            name = "Launch flutter",
            dartSdkPath = dart_path,
            flutterSdkPath = flutter_path,
            program = "${workspaceFolder}/lib/main.dart",
            cwd = "${workspaceFolder}",
            toolArgs = { "-d", device_id },
        }

        dap.listeners.after.event_initialized["flutter_launch"] = function()
            device_manager:set_launching(false)
        end
        
        dap.listeners.after.event_terminated["flutter_launch"] = function()
            device_manager:set_launching(false)
        end
        
        dap.listeners.after.disconnect["flutter_launch"] = function()
            device_manager:set_launching(false)
        end

        dap.run(config)
    end)
end

M.setup = function()
    dap.adapters.dart = {
        type = 'executable',
        command = 'dart',
        args = { 'debug_adapter' },
        options = {
            detached = false,
        }
    }
    dap.adapters.flutter = {
        type = 'executable',
        command = 'flutter',
        args = { 'debug_adapter' },
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
    }

    local vscode_configs = dap_ext.getconfigs(utils.get_vscode_cfg_path())

    local name = 'dart'
    dap.configurations[name] = dap.configurations[name] or {}

    for _, cfg in ipairs(configurations) do
        local exists = false
        if vscode_configs then
            for _, v in ipairs(vscode_configs) do
                if (v['type'] == 'dart' or v['type'] == 'flutter') and v['name'] == cfg['name'] then
                    exists = true
                end
            end
        end
        if not exists then
            table.insert(dap.configurations[name], cfg)
        end
    end

    vim.api.nvim_create_user_command("FlutterSwitchDevice", function()
        if device_manager:is_busy() then
            return
        end
        device_manager:switch_device()
    end, { desc = "Switch Flutter debug device" })

    vim.api.nvim_create_user_command("FlutterSelectDevice", function()
        if device_manager:is_busy() then
            return
        end
        device_manager:select_device_async(function(device_id)
            if device_id then
                vim.notify("Device selected: " .. device_id, vim.log.levels.INFO)
            end
        end)
    end, { desc = "Select Flutter debug device" })

    vim.api.nvim_create_user_command("FlutterRun", function()
        launch_flutter_with_device()
    end, { desc = "Run Flutter with device selection" })

    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'dart' },
        callback = function(ev)
            vim.keymap.set('n', '<F5>', function()
                launch_flutter_with_device()
            end, { buffer = ev.buf, desc = "Flutter: Start/Continue debug" })

            vim.keymap.set('n', '<S-F5>', function()
                dap.terminate()
                device_manager:set_launching(false)
            end, { buffer = ev.buf, desc = "Flutter: Stop debug" })

            vim.keymap.set('n', '<C-F5>', function()
                if device_manager:is_busy() then
                    return
                end
                device_manager:switch_device()
            end, { buffer = ev.buf, desc = "Switch Flutter device" })
        end,
    })

    vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*.dart' },
        callback = function()
            vim.defer_fn(function()
                device_manager:preload_devices()
            end, 500)
        end,
    })
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
    }

    utils.save_launch_json(configurations)
end

return M
