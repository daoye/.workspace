local lspconfig = require("lspconfig")

local M = {}

M.setup = function(opts)
    local lsp_opts = vim.tbl_deep_extend("force", {
        on_attach = opts.on_attach,
        capabilities = opts.capabilities,
    }, {
        filetypes = { "vue" }, -- Only handle .vue files, not js/ts files
        init_options = {
            vue = {
                hybridMode = false,
            },
        },
    })

    lspconfig.volar.setup(lsp_opts)
end

return M
