local lspconfig = require "lspconfig"
local coq = require "coq"
local csharpls_extend = require "csharpls_extended"

local M = {}

M.setup = function(opts)
	local config = vim.tbl_deep_extend("force", opts or {}, {
		handlers = {
			["textDocument/definition"] = csharpls_extend.handler,
			["textDocument/typeDefinition"] = csharpls_extend.handler,
		},
	})

	lspconfig.csharp_ls.setup(coq.lsp_ensure_capabilities(config))
end

return M
