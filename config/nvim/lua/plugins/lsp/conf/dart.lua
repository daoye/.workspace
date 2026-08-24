local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

-- Define the dart language server configuration if it doesn't exist
if not configs.dart then
    configs.dart = {
        default_config = {
            cmd = { "dart", "language-server", "--protocol=lsp" },
            filetypes = { "dart" },
            root_dir = lspconfig.util.root_pattern("pubspec.yaml", ".git"),
            single_file_support = true,
        },
    }
end

local M = {}

M.setup = function(opts)
    local lsp_opts = vim.tbl_deep_extend("force", {
        on_attach = opts.on_attach,
        capabilities = opts.capabilities,
    }, {
        filetypes = { "dart" },
        root_dir = lspconfig.util.root_pattern("pubspec.yaml", ".git"),
    })

    lspconfig.dart.setup(lsp_opts)
end

return M
