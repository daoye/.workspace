---@class util.minifile
local M = {}

---@param fs_entry table { fs_type = string, name = string, path = string}
function M.filter(fs_entry)
    return not vim.startswith(fs_entry.name, '.') and fs_entry.name ~= 'node_modules'
end

return M
