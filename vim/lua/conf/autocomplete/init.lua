local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
}

local M = {}
M.setup = function(opts)
    local luasnip = require("luasnip")
    local cmp = require("cmp")

    cmp.setup(vim.tbl_deep_extend("force", opts or {}, {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
            ["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
            -- C-b (back) C-f (forward) for snippet placeholder navigation.
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
            { name = "lazydev" },
            { name = "nvim_lsp" },
            { name = "nvim_lsp_signature_help" },
            { name = "luasnip" },
            { name = "path" },
        }, {
            { name = "buffer" },
            { name = "spell" },
        }),
        formatting = {
            format = function(entry, item)
                -- Kind icons
                item.kind = string.format("%s %s", kind_icons[item.kind], item.kind)
                -- Source
                item.menu = ({
                    nvim_lsp = "[LSP]",
                    nvim_lsp_signature_help = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    path = "[Path]",
                    buffer = "[Buffer]",
                    spell = "[Spell]",
                    dap = "[Dap]",
                })[entry.source.name]

                local widths = {
                    abbr = 40,
                    menu = 30,
                }

                for key, width in pairs(widths) do
                    if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                        item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
                    end
                end

                return item
            end,
        },
    }))
end

M.initialize = function()
    local cmp = require("cmp")

    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "buffer" },
            { name = "spell" },
        }),
    })

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
            { name = "cmdline" },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
    })

    cmp.setup.filetype({ "dap-repl" }, {
        sources = cmp.config.sources({
            { name = "dap" },
            { name = "spell" },
        }),
    })
end

return M
