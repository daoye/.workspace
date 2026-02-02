local M = {}

-- 存储用户选择的设备ID
M.selected_device = nil

-- 设备列表缓存
M.device_list = {}

-- 获取设备列表
function M:get_devices()
    local handle = io.popen("flutter devices --machine")
    if handle then
        local result = handle:read("*a")
        handle:close()

        local devices = {}
        for line in result:gmatch("[^\r\n]+") do
            if line ~= "" then
                local device_info = vim.fn.json_decode(line)
                if device_info and device_info.id and device_info.name then
                    table.insert(devices, {
                        id = device_info.id,
                        name = device_info.name,
                        platform = device_info.platform or "Unknown",
                        emulated = device_info.emulator or false
                    })
                end
            end
        end

        self.device_list = devices
        return devices
    end

    return {}
end

-- 选择设备
function M:select_device(callback)
    local devices = self:get_devices()

    if #devices == 0 then
        vim.notify("No Flutter devices found. Make sure a device is connected.", vim.log.levels.WARN)
        if callback then callback(nil) end
        return
    end

    if #devices == 1 then
        -- 如果只有一个设备，直接使用它
        self.selected_device = devices[1].id
        vim.notify("Using device: " .. devices[1].name .. " (" .. devices[1].id .. ")", vim.log.levels.INFO)
        if callback then callback(devices[1].id) end
        return
    end

    -- 如果有多个设备，让用户选择
    local device_names = {}
    for i, device in ipairs(devices) do
        local device_type = device.emulated and " (emulator)" or ""
        device_names[i] = string.format("%s (%s)%s", device.name, device.id, device_type)
    end

    vim.ui.select(device_names, {
        prompt = "Select a Flutter device:",
        format_item = function(item)
            return "  " .. item
        end,
    }, function(choice)
        if choice then
            -- 提取设备ID
            local selected_id = choice:match("%(([^)]+)%)")

            if selected_id then
                self.selected_device = selected_id
                vim.notify("Selected device: " .. choice, vim.log.levels.INFO)
                if callback then callback(selected_id) end
            else
                if callback then callback(nil) end
            end
        else
            if callback then callback(nil) end
        end
    end)
end

-- 获取当前选择的设备
function M:get_selected_device(callback)
    -- 每次都重新扫描设备
    local devices = self:get_devices()
    if #devices == 0 then
        vim.notify("No Flutter devices found. Make sure a device is connected.", vim.log.levels.WARN)
        if callback then callback(nil) end
        return
    end

    if #devices == 1 then
        -- 如果只有一个设备，直接使用它
        self.selected_device = devices[1].id
        if callback then callback(devices[1].id) end
        return
    end

    -- 如果没有选择设备或设备不可用，提示用户选择
    if not self.selected_device then
        self:select_device(callback)
        return
    end

    -- 检查当前选择的设备是否仍然可用
    local device_found = false
    for _, device in ipairs(devices) do
        if device.id == self.selected_device then
            device_found = true
            break
        end
    end

    if not device_found then
        -- 设备不再可用，重新选择
        self.selected_device = nil
        self:select_device(callback)
        return
    end

    if callback then callback(self.selected_device) end
end

-- 切换设备命令
function M:switch_device()
    self.selected_device = nil
    self:select_device(function(device_id)
        if device_id then
            vim.notify("Device switched to: " .. device_id, vim.log.levels.INFO)
        end
    end)
end

return M
