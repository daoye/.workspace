local lspconfig = require("lspconfig")

local M = {}

M.setup = function(opts)
    -- HTML LSP configuration
    local html_config = vim.tbl_deep_extend("force", opts or {}, {
        settings = {
            html = {
                format = {
                    enable = true,
                },
                suggest = {
                    html5 = true,
                },
            },
        },
    })

    lspconfig.html.setup(html_config)

    -- CSS/SCSS/LESS LSP configuration
    local css_config = vim.tbl_deep_extend("force", opts or {}, {
        settings = {
            css = {
                format = {
                    enable = true,
                },
                validate = true,
            },
            scss = {
                format = {
                    enable = true,
                },
                validate = true,
            },
            less = {
                format = {
                    enable = true,
                },
                validate = true,
            },
        },
    })

    lspconfig.cssls.setup(css_config)
end

return M
