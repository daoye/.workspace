local lspconfig = require "lspconfig"

local M = {}

M.setup = function(opts)
    local config = vim.tbl_deep_extend("force", opts or {}, {
        -- Additional configuration for omnisharp can go here
        -- cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(pid) },
        -- root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", ".git"),
    })

    lspconfig.omnisharp.setup(config)
end

return M
