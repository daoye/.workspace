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

-- Function to run flutter launch with device selection
local function run_flutter_launch(config_name)
    local device_id = nil
    device_manager:get_selected_device(function(id)
        device_id = id
    end)

    if not device_id then
        vim.notify("No device selected, aborting launch", vim.log.levels.WARN)
        return
    end

    -- Get the original configuration
    local configs = dap.configurations.dart
    local target_config = nil

    for _, config in ipairs(configs) do
        if config.name == config_name then
            target_config = vim.deepcopy(config)
            break
        end
    end

    if not target_config then
        vim.notify("Configuration not found: " .. config_name, vim.log.levels.ERROR)
        return
    end

    -- Add device argument
    target_config.toolArgs = { "-d", device_id }

    -- Run the debug session
    dap.run(target_config)
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
        },
        {
            type = "flutter",
            request = "launch",
            name = "Launch flutter (with device selection)",
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

    -- Create command to run flutter with device selection
    vim.api.nvim_create_user_command("FlutterRunWithDevice", function()
        run_flutter_launch("Launch flutter")
    end, { desc = "Run Flutter with device selection" })

    -- Create command to switch device
    vim.api.nvim_create_user_command("FlutterSwitchDevice", function()
        device_manager:switch_device()
    end, { desc = "Switch Flutter debug device" })

    -- Set up keymap for quick access
    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'dart' },
        callback = function()
            vim.keymap.set('n', '<leader>fd', function()
                run_flutter_launch("Launch flutter")
            end, { buffer = 0, desc = "Flutter debug with device selection" })
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
