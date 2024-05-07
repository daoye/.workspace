local M = {}

---@type PluginLspKeys
M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
    local format = function()
        require("plugins.lsp.format").format({ force = true })
    end
    if not M._keys then
        ---@class PluginLspKeys
        M._keys = {
            { "<leader>cd", vim.diagnostic.open_float,                 desc = "Line Diagnostics" },
            { "<leader>cl", "<cmd>LspInfo<cr>",                        desc = "Lsp Info" },
            { "gd",         "<cmd>Telescope lsp_definitions<cr>",      desc = "Goto Definition",       has = "definition" },
            { "<leader>lr", "<cmd>Telescope lsp_references<cr>",       desc = "References" },
            { "<leader>gd", vim.lsp.buf.declaration,                   desc = "Goto Declaration" },
            { "gi",         "<cmd>Telescope lsp_implementations<cr>",  desc = "Goto Implementation" },
            { "gy",         "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition" },
            { "K",          vim.lsp.buf.hover,                         desc = "Hover" },
            { "gK",         vim.lsp.buf.signature_help,                desc = "Signature Help",        has = "signatureHelp" },
            { "<c-k>",      vim.lsp.buf.signature_help,                mode = "i",                     desc = "Signature Help",   has = "signatureHelp" },
            { "]d",         M.diagnostic_goto(true),                   desc = "Next Diagnostic" },
            { "[d",         M.diagnostic_goto(false),                  desc = "Prev Diagnostic" },
            { "]e",         M.diagnostic_goto(true, "ERROR"),          desc = "Next Error" },
            { "[e",         M.diagnostic_goto(false, "ERROR"),         desc = "Prev Error" },
            { "]w",         M.diagnostic_goto(true, "WARN"),           desc = "Next Warning" },
            { "[w",         M.diagnostic_goto(false, "WARN"),          desc = "Prev Warning" },
            { "<leader>fs", format,                                    desc = "Format Document",       has = "documentFormatting" },
            { "<leader>fs", format,                                    desc = "Format Range",          mode = "v",                has = "documentRangeFormatting" },
            { "<leader>la", vim.lsp.buf.code_action,                   desc = "Code Action",           mode = { "n", "v" },       has = "codeAction" },
            {
                "<leader><leader>la",
                function()
                    vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
                end,
                desc = "Source Action",
                has = "codeAction",
            },
        }
        if require("util").has("inc-rename.nvim") then
            M._keys[#M._keys + 1] = {
                "<leader>rn",
                function()
                    local inc_rename = require("inc_rename")
                    return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
                end,
                expr = true,
                desc = "Rename",
                has = "rename",
            }
        else
            M._keys[#M._keys + 1] = { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
        end
    end
    return M._keys
end

function M.on_attach(client, buffer)
    local Keys = require("lazy.core.handler.keys")
    local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

    for _, value in ipairs(M.get()) do
        local keys = Keys.parse(value)
        if keys[2] == vim.NIL or keys[2] == false then
            keymaps[keys.id] = nil
        else
            keymaps[keys.id] = keys
        end
    end

    for _, keys in pairs(keymaps) do
        if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
            local opts = Keys.opts(keys)
            ---@diagnostic disable-next-line: no-unknown
            opts.has = nil
            opts.silent = opts.silent ~= false
            opts.buffer = buffer
            vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
        end
    end
end

function M.diagnostic_goto(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

return M