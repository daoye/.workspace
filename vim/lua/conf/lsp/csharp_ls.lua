local lspconfig = require "lspconfig"
local csharpls_extend = require "csharpls_extended"

local M = {}

M.setup = function(opts)
    local config = vim.tbl_deep_extend("force", opts or {}, {
        handlers = {
            ["textDocument/definition"] = csharpls_extend.handler,
            ["textDocument/typeDefinition"] = csharpls_extend.handler,
        },
    })

    lspconfig.csharp_ls.setup(config)
end

return M
