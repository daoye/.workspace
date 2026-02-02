-- OpenCode.nvim Configuration

local M = {}

-- OpenCode provider options
M.opts = function()
    return {
        provider = {
            enabled = "terminal",
            terminal = {
                -- Terminal provider options
            },
        },
        -- Custom prompts (extend built-in prompts)
        prompts = {
            -- Built-in prompts: diagnostics, diff, document, explain, fix, implement, optimize, review, test
        },
        -- Events configuration
        events = {
            reload = true, -- Auto-reload buffers when opencode edits files
        },
    }
end

M.setup = function(opts)
    local final_opts = vim.tbl_deep_extend("force", M.opts(), opts or {})

    ---@type opencode.Opts
    vim.g.opencode_opts = final_opts

    -- Required for opts.events.reload
    vim.o.autoread = true

    -- Setup status tracking hooks
    local conf = require("plugins.ai.conf")
    conf.setup_opencode_hooks()
end

return M
