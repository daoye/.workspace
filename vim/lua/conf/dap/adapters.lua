local dap = require('dap')

local M = {}

M.setup = function()
	-- js
	for _, name in ipairs({ 'node', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }) do
		dap.adapters[name] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "js-debug-adapter",
				args = { "${port}" },
			},
		}
	end

	for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
		require("dap").configurations[language] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-node",
				request = "attach",
				name = "Attach",
				processId = require 'dap.utils'.pick_process,
				cwd = "${workspaceFolder}",
			}
		}
	end


	-- csharp
	dap.adapters.coreclr = {
		type = 'executable',
		command = 'netcoredbg',
		args = { '--interpreter=vscode' }
	}

	dap.configurations.cs = {
		{
			type = "coreclr",
			name = "launch - netcoredbg",
			request = "launch",
			program = function()
				return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
			end,
		},
		{
			type = "coreclr",
			request = "attach",
			name = "Attach",
			processId = require 'dap.utils'.pick_process,
			cwd = "${workspaceFolder}",
		}
	}
end


return M
