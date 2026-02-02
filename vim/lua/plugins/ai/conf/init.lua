-- AI Configuration - Shared utilities for all AI providers
-- Supports both opencode.nvim and codecompanion.nvim

local M = {}

-- Shared state
M.processing = false
M.spinner_index = 1

local spinner_symbols = {
    "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏",
}

local function augroup(name)
    return vim.api.nvim_create_augroup("my_ai_" .. name, { clear = true })
end

-- Setup autocmds for CodeCompanion status tracking
M.setup_codecompanion_hooks = function()
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
end

-- Setup autocmds for OpenCode status tracking
M.setup_opencode_hooks = function()
    vim.api.nvim_create_autocmd("User", {
        pattern = "OpencodeEvent:*",
        group = augroup("OpenCodeHooks"),
        callback = function(args)
            local event = args.data and args.data.event
            if not event then return end

            if event.type == "session.updated" then
                M.processing = true
            elseif event.type == "session.idle" then
                M.processing = false
            end

            if package.loaded['lualine'] then
                require('lualine').refresh({ place = { 'statusline' } })
            end
        end,
    })
end

-- Get status for statusline display
M.get_status = function()
    if M.processing then
        M.spinner_index = (M.spinner_index % #spinner_symbols) + 1
        local provider = vim.g.ai_provider or "opencode"
        local icon = provider == "opencode" and "🚀" or "🤔"
        return icon .. " " .. spinner_symbols[M.spinner_index]
    else
        return ''
    end
end

-- Initialize hooks based on provider
M.setup_hooks = function()
    local provider = vim.g.ai_provider or "opencode"
    if provider == "opencode" then
        M.setup_opencode_hooks()
    elseif provider == "codecompanion" then
        M.setup_codecompanion_hooks()
    end
end

-- Switch AI provider (requires restart to take effect)
M.switch_provider = function(provider)
    if provider ~= "opencode" and provider ~= "codecompanion" then
        vim.notify("Invalid AI provider: " .. tostring(provider) .. ". Use 'opencode' or 'codecompanion'.", vim.log.levels.ERROR)
        return
    end

    vim.g.ai_provider = provider
    vim.notify("AI provider set to: " .. provider .. ". Restart Neovim to apply changes.", vim.log.levels.INFO)
end

-- Get current provider info
M.get_provider_info = function()
    local provider = vim.g.ai_provider or "opencode"
    local status = M.processing and "processing" or "idle"
    return {
        provider = provider,
        status = status,
    }
end

-- Create user commands
vim.api.nvim_create_user_command("AIProvider", function(opts)
    local args = opts.args
    if args == "" then
        -- Show current provider
        local info = M.get_provider_info()
        vim.notify("Current AI provider: " .. info.provider .. " (" .. info.status .. ")", vim.log.levels.INFO)
    else
        -- Switch provider
        M.switch_provider(args)
    end
end, {
    nargs = "?",
    complete = function()
        return { "opencode", "codecompanion" }
    end,
    desc = "Show or switch AI provider (opencode | codecompanion)",
})

-- Alias commands for quick switching
vim.api.nvim_create_user_command("AIOpenCode", function()
    M.switch_provider("opencode")
end, { desc = "Switch to OpenCode.nvim" })

vim.api.nvim_create_user_command("AICodeCompanion", function()
    M.switch_provider("codecompanion")
end, { desc = "Switch to CodeCompanion.nvim" })

return M