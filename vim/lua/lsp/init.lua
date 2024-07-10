local lspconfig = require("lspconfig")
local navic = require("nvim-navic")
local luasnip = require("luasnip")
local cmp = require("cmp")

local M = {}

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

local setup_cmp = function(opts)
	local cmp_opts = {
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
			['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
			-- C-b (back) C-f (forward) for snippet placeholder navigation.
			['<C-Space>'] = cmp.mapping.complete(),
			['<CR>'] = cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			},
			['<Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { 'i', 's' }),
			['<S-Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { 'i', 's' }),
		}),
		sources = cmp.config.sources(
			{
				{ name = 'nvim_lsp' },
				{ name = 'nvim_lsp_signature_help' },
				{ name = 'luasnip' },
				{ name = "path" },
			},
			{ name = 'buffer' }
		),
		formatting = {
			format = function(entry, item)
				-- Kind icons
				item.kind = string.format('%s %s', kind_icons[item.kind], item.kind)
				-- Source
				item.menu = ({
					nvim_lsp = "[LSP]",
					nvim_lsp_signature_help = "[LSP]",
					luasnip = "[LuaSnip]",
					nvim_lua = "[Lua]",
					path = "[Path]",
					buffer = "[Buffer]",
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
			end
		},
	}

	cmp.setup(cmp_opts)

	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	})

	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		}),
		matching = { disallow_symbol_nonprefix_matching = false }
	})
end


M.setup = function(opts)
	opts = opts or {}
	opts.capabilities = vim.tbl_deep_extend(
		"force",
		require("cmp_nvim_lsp").default_capabilities(),
		opts.capabilities or {}
	)

	require("mason-lspconfig").setup_handlers {
		function(server_name)
			local ok, mod = pcall(function() return require("lsp." .. server_name) end)

			if ok then
				mod.setup(opts)
			else
				lspconfig[server_name].setup(opts or {})
			end
		end,
	}


	setup_cmp(opts)
end


local function get()
	if M._keys then
		return M._keys
	end


	M._keys = {
		{
			"gd",
			function()
				if vim.bo.filetype == "cs" then
					-- There has some problem for csharp_ls with telescope
					vim.lsp.buf.definition()
				else
					vim.cmd("Telescope lsp_definitions")
				end
			end,
			desc = "Goto Definition",
			has = "definition"
		},
		{ "<leader>lr", "<cmd>Telescope lsp_references<cr>",       desc = "References" },
		{ "<leader>gd", vim.lsp.buf.declaration,                   desc = "Goto Declaration" },
		{ "gi",         "<cmd>Telescope lsp_implementations<cr>",  desc = "Goto Implementation" },
		{ "gy",         "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition" },
		{ "K",          vim.lsp.buf.hover,                         desc = "Hover" },
		{ "<c-k>",      vim.lsp.buf.signature_help,                mode = "i",                     desc = "Signature Help",   has = "signatureHelp" },
		{ "<leader>fs", vim.lsp.buf.format,                        desc = "Format Document",       has = "documentFormatting" },
		{ "<leader>fs", vim.lsp.buf.format,                        desc = "Format Range",          mode = "v",                has = "documentRangeFormatting" },
		{ "<leader>la", vim.lsp.buf.code_action,                   desc = "Code Action",           mode = { "n", "v" },       has = "codeAction" },
		{ "<leader>rn", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
	}

	return M._keys
end

---@param method string|string[]
local function has(buffer, method)
	if type(method) == "table" then
		for _, m in ipairs(method) do
			if has(buffer, m) then
				return true
			end
		end
		return false
	end

	method = method:find("/") and method or "textDocument/" .. method
	local clients = vim.lsp.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		if client.name == "csharp_ls" then
			return true
		end

		if client.supports_method(method) then
			return true
		end
	end

	return false
end


vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		local keyHandler = require("lazy.core.handler.keys")
		local maps = get()
		local keymaps = keyHandler.resolve(maps)

		for _, keys in pairs(keymaps) do
			local has = not keys.has or has(bufnr, keys.has)
			local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

			if has and cond then
				local opts = keyHandler.opts(keys)
				opts.cond = nil
				opts.has = nil
				opts.silent = opts.silent ~= false
				opts.buffer = bufnr

				vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
			end
		end


		-- for navic in lualine
		if client.server_capabilities.documentSymbolProvider then
			navic.attach(client, bufnr)
		end
	end,
})


return M
