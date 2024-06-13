---@class util.oil
local M = {}

local function get_git_ignored_files_in(dir)
    local found = vim.fs.find(".git", {
        upward = true,
        path = dir,
    })

    if #found == 0 then
        return {}
    end

    local cmd = string.format(
        'git -C %s ls-files --ignored --exclude-standard --others --directory | grep -v "/.*/"',
        -- 'git -C %s ls-files --ignored --exclude-standard --others --directory | grep -v "/.*\\/"',
        dir
    )

    local handle = io.popen(cmd)

    if handle == nil then
        return
    end

    local ignored_files = {}
    for line in handle:lines "*l" do
        line = line:gsub("/$", "")
        table.insert(ignored_files, line)
    end
    handle:close()

    return ignored_files
end

---@param name
function M.filter(name, bufnr)
    local dir = require('oil').get_current_dir()
    local ignored_files = get_git_ignored_files_in(dir)

    return vim.tbl_contains(ignored_files, name)
    -- return vim.tbl_contains(ignored_files, name) or not ivm.startswith(name, '.')
end

return M
