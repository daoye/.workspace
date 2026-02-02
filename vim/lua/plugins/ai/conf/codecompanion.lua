-- CodeCompanion.nvim Configuration

local M = {}

-- Default adapter: qwen
local DEFAULT_ADAPTER = "qwen"

M.opts = function()
    return {
        adapters = {
            -- HTTP adapters
            http = {
                -- Copilot adapter (built-in)
                copilot = "copilot",
            },
            -- ACP adapters (Agent Client Protocol)
            acp = {
                -- Qwen Code via ACP (qwen-code is a fork of gemini-cli)
                qwen = function()
                    return require("codecompanion.adapters").extend("gemini_cli", {
                        name = "qwen",
                        formatted_name = "Qwen Code",
                        commands = {
                            default = { "qwen", "--acp" },
                        },
                    })
                end,
                -- OpenCode via ACP
                opencode = "opencode",
                -- Gemini CLI via ACP
                gemini_cli = "gemini_cli",
                -- Hide presets to only show configured adapters
                opts = {
                    show_presets = false,
                },
            },
        },
        -- Interactions configuration (v17+ format)
        interactions = {
            chat = {
                adapter = DEFAULT_ADAPTER,
                keymaps = {
                    send = {
                        modes = { n = "<CR>", i = "<C-s>" },
                    },
                    close = {
                        modes = { n = "<C-c>" },
                    },
                },
            },
            inline = {
                adapter = DEFAULT_ADAPTER,
            },
        },
    }
end

M.setup = function(opts)
    require("codecompanion").setup(vim.tbl_deep_extend("force", opts or {}, M.opts()))

    -- Setup status tracking hooks
    local conf = require("plugins.ai.conf")
    conf.setup_codecompanion_hooks()
end

return M