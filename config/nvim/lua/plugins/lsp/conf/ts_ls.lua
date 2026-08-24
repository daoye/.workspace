local typescript_tools = require("typescript-tools")

local M = {}

M.setup = function(opts)
    local config = vim.tbl_deep_extend("force", opts or {}, {
        on_attach = function(client, bufnr)
            -- TypeScript-specific capabilities
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end,
    })

    typescript_tools.setup(config)
end

return M
