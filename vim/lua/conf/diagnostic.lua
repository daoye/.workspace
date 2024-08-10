local kind = {
    [vim.diagnostic.severity.ERROR] = " ",
    [vim.diagnostic.severity.WARN] = " ",
    [vim.diagnostic.severity.HINT] = " ",
    [vim.diagnostic.severity.INFO] = " ",
}

vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = {
        text = kind,
    },
    severity_sort = true,
    -- update_in_insert = true,
})

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
                return
            end
        end
        vim.diagnostic.open_float({
            scope = "cursor",
            focusable = true,
            close_events = {
                "CursorMoved",
                "CursorMovedI",
                "BufHidden",
                "InsertCharPre",
                -- "WinLeave",
            },
            format = function(diagnostic)
                return kind[diagnostic.severity] .. diagnostic.message
            end,
        })
    end,
})
