local M = {}

-- State
M.selected_device = nil
M.device_list = {}
M.loading = false
M.launching = false
M.last_fetch_time = 0
M._pending_callbacks = {} -- queue of callbacks waiting for device list

-- Cache TTL in seconds
local CACHE_DURATION = 30

-- Centralized spinner frames and frame rate (frames per second)
local SPINNER_FRAMES = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local FRAME_RATE = 120 -- higher -> faster animation (frames per second)

-- statusline refresh timer
local refresh_timer = nil

local function start_statusline_refresh()
    if refresh_timer then
        return
    end
    refresh_timer = vim.loop.new_timer()
    local interval_ms = math.max(10, math.floor(1000 / FRAME_RATE))
    refresh_timer:start(0, interval_ms, vim.schedule_wrap(function()
        -- redrawstatus is lightweight; used so lualine queries our status function frequently
        pcall(vim.cmd, "redrawstatus")
    end))
end

local function stop_statusline_refresh()
    if not refresh_timer then
        return
    end
    pcall(function()
        refresh_timer:stop()
        refresh_timer:close()
    end)
    refresh_timer = nil
    -- ensure one final redraw so status clears
    vim.schedule(function()
        pcall(vim.cmd, "redrawstatus")
    end)
end

-- Internal: call and clear pending callbacks with devices
local function run_pending_callbacks(devices)
    if not M._pending_callbacks then
        return
    end
    for _, cb in ipairs(M._pending_callbacks) do
        pcall(cb, devices)
    end
    M._pending_callbacks = {}
end

-- Get devices asynchronously. If loading is in progress, callbacks are queued.
function M:get_devices(callback, force_refresh)
    local now = os.time()
    if not force_refresh and #self.device_list > 0 and (now - self.last_fetch_time) < CACHE_DURATION then
        if callback then
            vim.schedule_wrap(callback)(self.device_list)
        end
        return
    end

    if self.loading then
        if callback then
            table.insert(self._pending_callbacks, callback)
        end
        return
    end

    self.loading = true
    start_statusline_refresh()

    -- Use flutter devices --machine (JSON). Some flutter versions emit JSON array; some emit per-line JSON.
    vim.system({ "flutter", "devices", "--machine" }, { text = true }, function(obj)
        vim.schedule(function()
            self.loading = false
            self.last_fetch_time = os.time()

            local devices = {}

            if obj.code == 0 and obj.stdout and #obj.stdout > 0 then
                local ok, parsed = pcall(vim.json.decode, obj.stdout)
                if ok and type(parsed) == "table" then
                    -- parsed is likely an array of device objects
                    for _, info in ipairs(parsed) do
                        if info and info.id and info.name then
                            table.insert(devices, {
                                id = info.id,
                                name = info.name,
                                platform = info.targetPlatform or info.platform or "Unknown",
                                emulated = info.emulator or false,
                            })
                        end
                    end
                else
                    -- fallback: try per-line json
                    for line in obj.stdout:gmatch("[^\r\n]+") do
                        if line and line ~= "" then
                            local ok2, info = pcall(vim.json.decode, line)
                            if ok2 and info and info.id and info.name then
                                table.insert(devices, {
                                    id = info.id,
                                    name = info.name,
                                    platform = info.targetPlatform or info.platform or "Unknown",
                                    emulated = info.emulator or false,
                                })
                            end
                        end
                    end
                end
            else
                if obj.stderr and obj.stderr ~= "" then
                    vim.notify("Error getting Flutter devices: " .. obj.stderr, vim.log.levels.WARN)
                end
            end

            self.device_list = devices

            -- stop statusline refresh only if not launching
            if not self.launching then
                stop_statusline_refresh()
            end

            -- call provided callback first (if any)
            if callback then
                pcall(callback, devices)
            end

            -- then run queued callbacks
            run_pending_callbacks(devices)
        end)
    end)
end

-- Present selection UI and set selected_device (async)
function M:select_device_async(callback)
    self:get_devices(function(devices)
        if #devices == 0 then
            vim.notify("No Flutter devices found. Make sure a device is connected.", vim.log.levels.WARN)
            if callback then callback(nil) end
            return
        end

        if #devices == 1 then
            self.selected_device = devices[1].id
            vim.notify(string.format("Using device: %s (%s)", devices[1].name, devices[1].id), vim.log.levels.INFO)
            if callback then callback(devices[1].id) end
            return
        end

        local items = {}
        for i, d in ipairs(devices) do
            local type_suffix = d.emulated and " (emulator)" or ""
            items[i] = string.format("%s (%s)%s", d.name, d.id, type_suffix)
        end

        -- show selection; when user picks, extract index and set device
        vim.ui.select(items, { prompt = "Select a Flutter device:" }, function(choice, idx)
            if choice and idx and devices[idx] then
                self.selected_device = devices[idx].id
                vim.notify(string.format("Selected device: %s", devices[idx].name), vim.log.levels.INFO)
                if callback then callback(devices[idx].id) end
            else
                if callback then callback(nil) end
            end
        end)
    end, false)
end

-- Ensure a device is selected; if not, prompt. callback(device_id or nil)
function M:ensure_device_selected(callback)
    if self.selected_device then
        -- quick verification against cached list
        if #self.device_list > 0 then
            for _, d in ipairs(self.device_list) do
                if d.id == self.selected_device then
                    if callback then vim.schedule_wrap(callback)(self.selected_device) end
                    return
                end
            end
        end
        -- if we have a selected device but it's not in cache, refresh and check
        self:get_devices(function(devices)
            for _, d in ipairs(devices) do
                if d.id == self.selected_device then
                    if callback then callback(self.selected_device) end
                    return
                end
            end
            -- not found, clear and prompt
            self.selected_device = nil
            self:select_device_async(callback)
        end, true)
    else
        -- Not selected: if a get_devices is already in-flight, queue an action to show selection when ready
        self:select_device_async(callback)
    end
end

-- Switch device explicitly
function M:switch_device(callback)
    self.selected_device = nil
    self:select_device_async(function(device_id)
        if device_id then
            vim.notify("Device switched successfully", vim.log.levels.INFO)
        end
        if callback then callback(device_id) end
    end)
end

-- Preload device list in background
function M:preload_devices()
    if not self.loading then
        self:get_devices(nil, false)
    end
end

-- Mark launching state (affects status and refresh)
function M:set_launching(state)
    self.launching = state and true or false
    if self.launching then
        start_statusline_refresh()
    else
        -- only stop refresh if not loading
        if not self.loading then
            stop_statusline_refresh()
        end
    end
end

-- is_busy used to avoid duplicate launches: only true when a launch is in progress
function M:is_busy()
    return self.launching
end

function M:is_loading()
    return self.loading
end

function M:get_selected_device()
    return self.selected_device
end

function M:get_selected_device_info()
    if not self.selected_device then return nil end
    for _, d in ipairs(self.device_list) do
        if d.id == self.selected_device then return d end
    end
    return nil
end

-- Return a short status string for statusline (or nil)
function M:get_loading_status()
    if not (self.loading or self.launching) then
        return nil
    end
    local spinner = SPINNER_FRAMES
    local idx = (math.floor(os.clock() * FRAME_RATE) % #spinner) + 1
    if self.launching then
        return "🚀 " .. spinner[idx] .. " Launching..."
    else
        return "📱 " .. spinner[idx] .. " Loading devices..."
    end
end

-- Friendly device info for statusline
function M:get_current_device_info()
    if not self.selected_device then return nil end
    for _, d in ipairs(self.device_list) do
        if d.id == self.selected_device then
            local icon = d.emulated and "📱" or "📲"
            return string.format("%s %s", icon, d.name)
        end
    end
    return "📱 " .. self.selected_device
end

return M
