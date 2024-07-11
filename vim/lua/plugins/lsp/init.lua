return {
	{
		"williamboman/mason.nvim",
		config = true
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = true
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		opts = {
			-- add any global capabilities here
			capabilities = {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			},
		},
		init = function()
		end,
		config = function(_, opts)
			require("conf.lsp").setup(opts)
		end
	},
	-- csharp
	{
		"Decodetalkers/csharpls-extended-lsp.nvim"
	},

	-- nvim lua
	{ "folke/neodev.nvim", opts = {} },

	-- fold
	{
		"kevinhwang91/nvim-ufo",
		-- enabled = false,
		dependencies = {
			"kevinhwang91/promise-async",
			"neovim/nvim-lspconfig",
		},
		event = { "VeryLazy" },
		opts = {
			default = {
				close_fold_kinds_for_ft = { "imports", "comment" },
			}
		},
		keys = {
			{
				"zR",
				function()
					require("ufo").openAllFolds()
				end,
				desc = "Open all folds",
				mode = { "n" },
			},
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "Close all folds",
				mode = { "n" },
			},
			{
				"zr",
				function()
					require("ufo").openFoldsExceptKinds()
				end,
				desc = "Open folds",
				mode = { "n" },
			},
			{
				"zM",
				function()
					require("ufo").closeFoldsWith()
				end,
				desc = "Close folds",
				mode = { "n" },
			},
		},
	},
}
