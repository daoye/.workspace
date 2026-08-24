-- Console 窗口管理器
local M = {}

-- 存储消息的表
M.messages = {}
M.bufnr = nil
M.winid = nil
M.console_opened = false

-- 控制台日志文件路径
M.log_file = vim.fn.stdpath("data") .. "/console_log.txt"

-- 从文件加载现有控制台条目
function M:load_from_file()
    local file = io.open(self.log_file, "r")
    if file then
        for line in file:lines() do
            table.insert(self.messages, line)
        end
        file:close()
    end
end

-- 将控制台条目追加到文件
function M:append_to_file(entry)
    local file = io.open(self.log_file, "a")
    if file then
        file:write(entry .. "\n")
        file:close()
    end
end

-- 清空控制台日志文件
function M:clear_log_file()
    local file = io.open(self.log_file, "w")
    if file then
        file:write("")
        file:close()
    end
end

-- 创建或获取控制台缓冲区
function M:get_buffer()
    if not self.bufnr or not vim.api.nvim_buf_is_valid(self.bufnr) then
        self.bufnr = vim.api.nvim_create_buf(false, true) -- 创建一个未命名的缓冲区
        vim.api.nvim_buf_set_option(self.bufnr, "buftype", "nofile")
        vim.api.nvim_buf_set_option(self.bufnr, "bufhidden", "hide")
        vim.api.nvim_buf_set_option(self.bufnr, "buflisted", false)
        vim.api.nvim_buf_set_option(self.bufnr, "filetype", "console")
        vim.api.nvim_buf_set_option(self.bufnr, "modifiable", true)

        -- 从文件加载历史控制台条目
        self:load_from_file()
        local lines = {}
        for _, entry in ipairs(self.messages) do
            table.insert(lines, entry)
        end
        vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines)

        -- 设置缓冲区名称
        vim.api.nvim_buf_set_name(self.bufnr, "Console")
    end
    return self.bufnr
end

-- 切换控制台窗口
function M:toggle_console()
    local bufnr = self:get_buffer()

    -- 检查控制台窗口是否已经打开
    if self.winid and vim.api.nvim_win_is_valid(self.winid) then
        -- 如果窗口存在，关闭它
        vim.api.nvim_win_close(self.winid, true)
        self.winid = nil
        self.console_opened = false
        return
    end

    -- 创建水平分割窗口，高度为10行
    vim.cmd("botright new")
    self.winid = vim.api.nvim_get_current_win()

    -- 设置窗口属性
    vim.api.nvim_win_set_buf(self.winid, bufnr)
    vim.api.nvim_win_set_height(self.winid, 10)
    vim.api.nvim_win_set_option(self.winid, "winfixheight", true)
    vim.api.nvim_win_set_option(self.winid, "winfixwidth", true)
    vim.api.nvim_win_set_option(self.winid, "number", false)
    vim.api.nvim_win_set_option(self.winid, "relativenumber", false)
    vim.api.nvim_win_set_option(self.winid, "signcolumn", "no")
    vim.api.nvim_win_set_option(self.winid, "foldenable", false)

    -- 设置缓冲区名称
    vim.api.nvim_buf_set_name(bufnr, "Console")

    self.console_opened = true
end

-- 检查控制台是否打开
function M:is_console_opened()
    return self.console_opened and self.winid and vim.api.nvim_win_is_valid(self.winid)
end

-- 添加控制台条目到缓冲区
function M:add_console_entry(msg, level)
    local timestamp = os.date("%H:%M:%S")
    local level_str = level or "INFO"

    -- 处理可能包含换行符的消息，将其拆分为多行
    local msg_str = tostring(msg)
    local msg_lines = vim.split(msg_str, "\n", { plain = true })

    for _, line in ipairs(msg_lines) do
        local formatted_entry = string.format("[%s] [%s] %s", timestamp, level_str, line)

        table.insert(self.messages, formatted_entry)
        -- 将控制台条目追加到日志文件
        self:append_to_file(formatted_entry)

        local bufnr = self:get_buffer()
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        table.insert(lines, formatted_entry)

        -- 限制缓冲区行数，保留最新的100行
        if #lines > 100 then
            local excess = #lines - 100
            -- 移除最早的行
            lines = { unpack(lines, excess + 1) }
        end

        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

        -- 如果控制台窗口打开，自动滚动到底部
        if self:is_console_opened() then
            vim.api.nvim_win_set_cursor(self.winid, { #lines, 0 })
        end
    end
end

-- 获取状态摘要用于状态栏显示
function M:get_status_summary()
    local error_count = 0
    local warn_count = 0

    for _, entry in ipairs(self.messages) do
        if string.find(entry, "%[ERROR%]") then
            error_count = error_count + 1
        elseif string.find(entry, "%[WARN%]") then
            warn_count = warn_count + 1
        end
    end

    local status_parts = {}
    if error_count > 0 then
        table.insert(status_parts, "ERR:" .. error_count)
    end
    if warn_count > 0 then
        table.insert(status_parts, "WARN:" .. warn_count)
    end

    if #status_parts == 0 then
        return ""
    end

    return "[" .. table.concat(status_parts, " ") .. "]"
end

-- 重写 vim.api.nvim_echo 函数来拦截控制台输出
local original_nvim_echo = vim.api.nvim_echo
function vim.api.nvim_echo(messages, history, chunk)
    -- 将消息添加到我们的控制台
    local full_msg = ""
    for _, msg_chunk in ipairs(messages) do
        full_msg = full_msg .. msg_chunk[1]
    end

    -- 确定消息级别
    local level = "INFO"
    for _, msg_chunk in ipairs(messages) do
        local hl_group = msg_chunk[2]
        if hl_group == "ErrorMsg" then
            level = "ERROR"
            break
        elseif hl_group == "WarningMsg" then
            level = "WARN"
            break
        elseif hl_group == "MoreMsg" or hl_group == "Question" then
            level = "INFO"
            break
        end
    end

    M:add_console_entry(full_msg, level)

    -- 根据用户设置决定是否显示原始消息
    if vim.g.show_console_in_popup == false then
        -- 不显示原始弹窗，只记录到控制台
        return
    else
        -- 调用原始函数
        return original_nvim_echo(messages, history, chunk)
    end
end

-- 重写 vim.notify 来拦截通知
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
    local level_str = "INFO"
    if level == vim.log.levels.ERROR then
        level_str = "ERROR"
    elseif level == vim.log.levels.WARN then
        level_str = "WARN"
    elseif level == vim.log.levels.INFO then
        level_str = "INFO"
    elseif level == vim.log.levels.DEBUG then
        level_str = "DEBUG"
    end

    M:add_console_entry(tostring(msg), level_str)

    -- 根据用户设置决定是否显示原始通知
    if vim.g.show_console_in_popup == false then
        -- 不显示原始通知，只记录到控制台
        return
    else
        -- 调用原始函数
        return original_notify(msg, level, opts)
    end
end

-- 创建命令来切换控制台
vim.api.nvim_create_user_command("Console", function()
    M:toggle_console()
end, { desc = "Toggle console window" })

-- 创建清除命令
vim.api.nvim_create_user_command("ClearConsole", function()
    if M.bufnr and vim.api.nvim_buf_is_valid(M.bufnr) then
        vim.api.nvim_buf_set_lines(M.bufnr, 0, -1, false, {})
        M.messages = {}
        -- 清空日志文件
        M:clear_log_file()
    end
end, { desc = "Clear console buffer" })

-- 默认不显示弹窗，只记录到控制台
if vim.g.show_console_in_popup == nil then
    vim.g.show_console_in_popup = false
end

-- 返回模块，供其他插件使用
return M
