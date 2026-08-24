local M = {}

-- Run a shell command and handle the output
function M.run_command(cmd)
    local handle = io.popen(cmd)
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result
    end
    return nil
end

return M
