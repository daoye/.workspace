local M = {}

M.processing = false
M.spinner_index = 1

local spinner_symbols = {
    "⠋",
    "⠙",
    "⠹",
    "⠸",
    "⠼",
    "⠴",
    "⠦",
    "⠧",
    "⠇",
    "⠏",
}

local function augroup(name)
    return vim.api.nvim_create_augroup("my_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = augroup("CodeCompanionHooks"),
    callback = function(request)
        if request.match == "CodeCompanionRequestStarted" then
            M.processing = true
        elseif request.match == "CodeCompanionRequestFinished" then
            M.processing = false
        end

        if package.loaded['lualine'] then
            require('lualine').refresh({ place = { 'statusline' } })
        end
    end,
})

M.get_status = function()
    if M.processing then
        M.spinner_index = (M.spinner_index % #spinner_symbols) + 1
        return "🤔 " .. spinner_symbols[M.spinner_index]
    else
        return ''
    end
end

M.opts = function()
    return {
        strategies = {
            chat = {
                adapter = "copilot",
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
                adapter = "copilot",
            },
        },
    }
end

M.setup = function(opts)
    require("codecompanion").setup(vim.tbl_deep_extend("force", opts or {}, {
        strategies = {
            chat = {
                adapter = "copilot",
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
                adapter = "copilot",
            },
        },
    }))
end

return M
