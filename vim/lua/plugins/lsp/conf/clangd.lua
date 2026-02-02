local lspconfig = require("lspconfig")

local M = {}

M.setup = function(opts)
    local config = vim.tbl_deep_extend("force", opts or {}, {
        settings = {
            clangd = {
                -- Enable indexing
                ["--background-index"] = true,
                -- Use clangd for C and C++
                ["--clang-tidy"] = true,
                ["--header-insertion=iwyu"],
                ["--completion-style=detailed"],
                ["--function-arg-placeholders"] = true,
                ["--fallback-style=llvm"],
            },
        },
    })

    lspconfig.clangd.setup(config)
end

return M
