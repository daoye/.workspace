local lspconfig = require("lspconfig")

local M = {}

M.setup = function(opts)
    local config = vim.tbl_deep_extend("force", opts or {}, {
        settings = {
            pylsp = {
                configurationSources = { "flake8", "pycodestyle", "pyflakes" },
                plugins = {
                    pylint = { enabled = false },
                    pyflakes = { enabled = true },
                    pycodestyle = { enabled = true },
                    mccabe = { enabled = true },
                    yapf = { enabled = false },
                    black = { enabled = true },
                    flake8 = { enabled = false },
                    jedi = { enabled = true },
                    jedi_completion = { enabled = true },
                    jedi_definition = { enabled = true },
                    jedi_hover = { enabled = true },
                    jedi_references = { enabled = true },
                    jedi_signature_help = { enabled = true },
                    jedi_symbols = { enabled = true },
                },
            },
        },
    })

    lspconfig.pyright.setup(config)
end

return M

