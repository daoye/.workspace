local lspconfig = require("lspconfig")

local M = {}

M.setup = function(opts)
    local config = vim.tbl_deep_extend("force", opts or {}, {
        settings = {
            ["rust-analyzer"] = {
                -- Enable clippy
                checkOnSave = {
                    command = "clippy",
                    extraArgs = { "--no-deps" },
                },
                cargo = {
                    loadOutDirsFromCheck = true,
                },
                procMacro = {
                    enable = true,
                },
            },
        },
    })

    lspconfig.rust_analyzer.setup(config)
end

return M

