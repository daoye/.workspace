local lspconfig = require("lspconfig")

local M = {}

M.setup = function(opts)
    local lsp_opts = vim.tbl_deep_extend("force", {
        on_attach = opts.on_attach,
        capabilities = opts.capabilities,
    }, {
        filetypes = { "dockerfile", "Dockerfile" },
        root_dir = lspconfig.util.root_pattern("Dockerfile", ".git"),
    })

    lspconfig.dockerls.setup(lsp_opts)
end

return M
