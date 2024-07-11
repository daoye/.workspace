local dap = require("dap")
local M = {}

M.setup = function()
	vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

	local kind = {
		Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
		Breakpoint = " ",
		-- Breakpoint = "󰠭 ",
		BreakpointCondition = " ",
		BreakpointRejected = { " ", "DiagnosticError" },
		LogPoint = ".>",
	}

	for name, sign in pairs(kind) do
		sign = type(sign) == "table" and sign or { sign }
		vim.fn.sign_define(
			"Dap" .. name,
			{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
		)
	end

	dap.listeners.after.event_initialized["aprilzz"] = function(session)
		dap.repl.open({ height = 10 }, "belowright split")
	end
	dap.set_log_level("TRACE")

	require("conf.dap.adapters").setup()

	-- repl auto complete
	-- require("cmp").setup.filetype({ "dap-repl" }, {
	-- 	sources = {
	-- 		{ name = "dap" },
	-- 	},
	-- })
end

return M
