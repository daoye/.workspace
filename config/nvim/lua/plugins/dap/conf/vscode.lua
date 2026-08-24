local M = {}

local function find_vscode_launch_json()
    local current_dir = vim.fn.getcwd()
    local home_dir = vim.env.HOME

    -- Look for .vscode directory in current and parent directories
    while current_dir and current_dir ~= home_dir do
        local vscode_path = current_dir .. "/.vscode"
        local launch_json_path = current_dir .. "/.vscode/launch.json"

        -- Check if .vscode directory exists
        local vscode_stat = vim.loop.fs_stat(vscode_path)
        if vscode_stat and vscode_stat.type == "directory" then
            -- Check if launch.json exists
            local launch_stat = vim.loop.fs_stat(launch_json_path)
            if launch_stat and launch_stat.type == "file" then
                return launch_json_path
            end
        end

        -- Move up one directory level
        local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
        if parent_dir == current_dir then
            -- We've reached the root directory
            break
        end
        current_dir = parent_dir
    end

    return nil
end

M.load_config = function()
    local launch_json_path = find_vscode_launch_json()
    if not launch_json_path then
        print("No .vscode/launch.json file found in current or parent directories")
        return
    end

    local file = io.open(launch_json_path, "r")
    if not file then
        print("Could not open " .. launch_json_path)
        return
    end

    local content = file:read("*all")
    file:close()

    local success, json = pcall(vim.fn.json_decode, content)
    if not success then
        print("Could not parse " .. launch_json_path)
        return
    end

    if not json.configurations or type(json.configurations) ~= "table" then
        print("No configurations found in " .. launch_json_path)
        return
    end

    local dap = require("dap")
    for _, config in ipairs(json.configurations) do
        -- Register the configuration with nvim-dap
        local lang = config.type or "unknown"
        if not dap.configurations[lang] then
            dap.configurations[lang] = {}
        end
        table.insert(dap.configurations[lang], config)
    end

    print("Loaded " .. #json.configurations .. " configurations from " .. launch_json_path)
end

-- Function to generate a default launch.json file if none exists
M.generate_config = function()
    local current_dir = vim.fn.getcwd()
    local vscode_dir = current_dir .. "/.vscode"
    local launch_json_path = current_dir .. "/.vscode/launch.json"

    -- Create .vscode directory if it doesn't exist
    local vscode_stat = vim.loop.fs_stat(vscode_dir)
    if not vscode_stat then
        vim.fn.mkdir(vscode_dir, "p")
    end

    -- Check if launch.json already exists
    local launch_stat = vim.loop.fs_stat(launch_json_path)
    if launch_stat then
        print("launch.json already exists at " .. launch_json_path)
        return
    end

    -- Generate a default launch.json with configurations for common languages
    local default_config = {
        version = "0.2.0",
        configurations = {
            {
                name = "Python: Current File",
                type = "python",
                request = "launch",
                program = "${file}",
                console = "integratedTerminal",
                justMyCode = false,
            },
            {
                name = "Node.js: Current File",
                type = "node",
                request = "launch",
                program = "${file}",
                skipFiles = { "<node_internals>/**" },
            },
            {
                name = "C/C++: Launch",
                type = "cppdbg",
                request = "launch",
                program = "${workspaceFolder}/a.out",
                cwd = "${workspaceFolder}",
                stopAtEntry = false,
                MIMode = "gdb",
            },
            {
                name = "Rust: Launch",
                type = "codelldb",
                request = "launch",
                program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
            {
                name = "HTML: Open in Chrome",
                type = "chrome",
                request = "launch",
                url = "http://localhost:3000",
                webRoot = "${workspaceFolder}",
            },
        }
    }

    local json_str = vim.fn.json_encode(default_config)

    local file = io.open(launch_json_path, "w")
    if file then
        file:write(json_str)
        file:close()
        print("Generated default launch.json at " .. launch_json_path)
    else
        print("Could not create " .. launch_json_path)
    end
end

return M
