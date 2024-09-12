local lspconfig = require("lspconfig")
local mason_registry = require("mason-registry")
-- local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/typescript-plugin"
local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server"

local M = {}

M.setup = function(opts)
    local conf = vim.tbl_deep_extend("force", opts or {}, {
        init_options = {
            plugins = {
                {
                    -- name = "@vue/typescript-plugin",
                    name = "@vue/typescript-plugin",
                    location = vue_language_server_path,
                    languages = { "vue" },
                },
            },
        },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    })

    lspconfig.ts_ls.setup(conf)

    -- vue
    lspconfig.volar.setup({})
end

return M
