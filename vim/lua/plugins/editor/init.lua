---@class util.oil
local M = {}

M.root_patterns = { ".git", "lua" }

local git_ignored = setmetatable({}, {
	__index = function(self, key)
		local proc = vim.system(
			{ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
			{
				cwd = key,
				text = true,
			}
		)
		local result = proc:wait()
		local ret = {}
		if result.code == 0 then
			for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
				-- Remove trailing slash
				line = line:gsub("/$", "")
				table.insert(ret, line)
			end
		end

		rawset(self, key, ret)
		return ret
	end,
})

---@param name
function M.filter(name, _)
	-- dotfiles are always considered hidden
	if vim.startswith(name, ".") then
		return true
	end
	local dir = require("oil").get_current_dir()
	-- if no local directory (e.g. for ssh connections), always show
	if not dir then
		return false
	end
	-- Check if file is gitignored
	return vim.list_contains(git_ignored[dir], name)
end

function M.get_root()
	local path = vim.api.nvim_buf_get_name(0)
	local root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
	return root and vim.fs.dirname(root) or vim.uv.cwd()
	-- ---@type string?
	-- local path = vim.api.nvim_buf_get_name(0)
	-- path = path ~= "" and vim.uv.fs_realpath(path) or nil
	-- ---@type string[]
	-- local roots = {}
	-- if path then
	--     for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
	--         local workspace = client.config.workspace_folders
	--         local paths = workspace and vim.tbl_map(function(ws)
	--             return vim.uri_to_fname(ws.uri)
	--         end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
	--         for _, p in ipairs(paths) do
	--             local r = vim.loop.fs_realpath(p)
	--             if path:find(r, 1, true) then
	--                 roots[#roots + 1] = r
	--             end
	--         end
	--     end
	-- end

	-- table.sort(roots, function(a, b)
	--     -- return #a > #b
	--     return #a > #b
	-- end)

	-- ---@type string?
	-- local root = roots[1]
	-- if not root then
	--     path = path and vim.fs.dirname(path) or vim.uv.cwd()
	--     ---@type string?
	--     root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
	--     root = root and vim.fs.dirname(root) or vim.uv.cwd()
	-- end

	-- ---@cast root string
	-- return root
end

-- this will return a function that calls telescope.
-- cwd will default to util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
	local params = { builtin = builtin, opts = opts }
	return function()
		builtin = params.builtin
		opts = params.opts
		opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
		if builtin == "files" then
			builtin = "find_files"
			-- if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
			--   opts.recurse_submodules = true
			--   -- opts.show_untracked = true
			--   builtin = "git_files"
			-- else
			--   builtin = "find_files"
			-- end
		end

		require("telescope.builtin")[builtin](opts)
	end
end

return {
	-- theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = true,
				noice = true,
				mini = true,
				barbar = true,
				mason = true,
				mini = true,
				treesitter_context = true,
				leap = true,
			},
		},
		init = function()
			vim.cmd.colorscheme("catppuccin")
		end
	},

	-- better vim.ui
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},

	-- file explorer
	{
		'stevearc/oil.nvim',
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			keymaps = {
				["?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-v>"] = "actions.select_vsplit",
				["<C-h>"] = "actions.select_split",
				["<C-t>"] = "actions.select_tab",
				["<C-p>"] = "actions.preview",
				["q"] = "actions.close",
				["<Leader>r"] = "actions.refresh",
				["<BS>"] = "actions.parent",
				["<ESC>"] = "actions.open_cwd",
				["cd"] = "actions.cd",
				["~"] = "actions.tcd",
				["<Leader>s"] = "actions.change_sort",
				["<Leader><Leader>"] = "actions.open_external",
				["<Leader>."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
			},
			-- Set to false to disable all of the above keymaps
			use_default_keymaps = false,

			-- watch file system and auto reload
			experimental_watch_for_changes = true,
			view_options = {
				show_hidden = false,
				is_hidden_file = function(name, bufnr)
					return M.filter(name, bufnr)
					-- return vim.startswith(name, ".") or name == 'bin' or name == 'obj'
				end,
			},
		},

		keys = {
			{
				"<space>f",
				function()
					-- require("oil").open(vim.api.nvim_buf_get_name(0), false)
					require("oil").open()
				end,
				desc = "Explorer focus current file",
			},
			{
				"<space>e",
				function()
					require("oil").open(vim.loop.cwd())
				end,
				desc = "Explorer",
			},
		},
	},

	-- search/replace
	{
		"nvim-pack/nvim-spectre",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			find_engine = {
				-- rg is map with finder_cmd
				["rg"] = {
					options = {
						["ignore-case"] = {
							value = "--ignore-case",
							icon = "[I]",
							desc = "ignore case",
						},
						["hidden"] = {
							value = "--hidden",
							desc = "hidden file",
							icon = "[H]",
						},
						["word"] = {
							value = "--word-regexp",
							icon = "[W]",
							desc = "match word",
						},
					},
				},
			},
		},
		-- stylua: ignore
		keys = {
			{
				"<leader>sw",
				function() require("spectre").open() end,
				desc =
				"Replace in files (Spectre)"
			},
			{
				"<leader>sf",
				function() require("spectre").open_file_search({ select_word = true }) end,
				desc =
				"Replace in current file(Spectre)"
			},
		},
	},

	-- fuzzy file search
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function()
					require("telescope").load_extension("fzf")
				end,
			},
		},
		keys = {
			{ "<leader>fg",      M.telescope("live_grep"),                          desc = "Grep (root dir)" },
			{ "<leader>fG",      M.telescope("live_grep", { cwd = false }),         desc = "Grep (cwd)" },
			{ "<leader>:",       "<cmd>Telescope command_history<cr>",              desc = "Command History" },
			{ "<leader><space>", M.telescope("files"),                              desc = "Find Files (root dir)" },
			-- find
			{ "<leader>fb",      "<cmd>Telescope buffers<cr>",                      desc = "Buffers" },
			{ "<leader>ff",      M.telescope("files"),                              desc = "Find Files (root dir)" },
			{ "<leader>fF",      M.telescope("find_files"),                         desc = "Find All Files (root dir)" },
			{ "<leader>fr",      "<cmd>Telescope oldfiles<cr>",                     desc = "Recent" },
			{ "<leader>fR",      M.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
			{ "<leader>fk",      "<cmd>Telescope keymaps<cr>",                      desc = "Keymaps" },
			{ "<leader>f?",      "<cmd>Telescope help_tags<cr>",                    desc = "Help" },
			{ "<leader>fw",      M.telescope("grep_string"),                        desc = "Word (root dir)" },
			{ "<leader>fW",      M.telescope("grep_string", { cwd = false }),       desc = "Word (cwd)" },
			-- git
			{ "<leader>gc",      "<cmd>Telescope git_commits<CR>",                  desc = "commits" },
			{ "<leader>gs",      "<cmd>Telescope git_status<CR>",                   desc = "status" },
			-- search
			{ "<leader>sa",      "<cmd>Telescope autocommands<cr>",                 desc = "Auto Commands" },
			{ "<leader>sc",      "<cmd>Telescope command_history<cr>",              desc = "Command History" },
			{ "<leader>sC",      "<cmd>Telescope commands<cr>",                     desc = "Commands" },
			{ "<leader>sd",      "<cmd>Telescope diagnostics bufnr=0<cr>",          desc = "Document diagnostics" },
			{ "<leader>sD",      "<cmd>Telescope diagnostics<cr>",                  desc = "Workspace diagnostics" },
			{ "<leader>sh",      "<cmd>Telescope help_tags<cr>",                    desc = "Help Pages" },
			{
				"<leader>sH",
				"<cmd>Telescope highlights<cr>",
				desc = "Search Highlight Groups",
			},
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>",     desc = "Key Maps" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>",   desc = "Man Pages" },
			{ "<leader>fm", "<cmd>Telescope marks<cr>",       desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Telescope resume<cr>",      desc = "Resume" },
			{
				"<leader>uC",
				M.telescope("colorscheme", { enable_preview = true }),
				desc = "Colorscheme with preview",
			},

			{
				"<space>ff",
				"<cmd>Telescope current_buffer_fuzzy_find fuzzy=true<cr>",
				desc = "Search in currentfile",
				mode = { "n", "v" },
			},

			{
				"<leader>ls",
				M.telescope("lsp_document_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				}),
				desc = "Goto Symbol",
			},
			{
				"<leader><leader>ls",
				M.telescope("lsp_dynamic_workspace_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				}),
				desc = "Goto Symbol (Workspace)",
			},
		},
		opts = function(p, opts)
			return vim.tbl_deep_extend("force", opts or {}, {
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					wrap_results = true,
					mappings = {
						i = {
							["<c-t>"] = function(...)
								return require("trouble.providers.telescope").open_with_trouble(...)
							end,
							["<a-t>"] = function(...)
								return require("trouble.providers.telescope").open_selected_with_trouble(...)
							end,
							["<a-i>"] = function()
								M.telescope("find_files", { no_ignore = true })()
							end,
							["<a-h>"] = function()
								M.telescope("find_files", { hidden = true })()
							end,
							["<C-Down>"] = function(...)
								return require("telescope.actions").cycle_history_next(...)
							end,
							["<C-Up>"] = function(...)
								return require("telescope.actions").cycle_history_prev(...)
							end,
							["<C-d>"] = function(...)
								return require("telescope.actions").preview_scrolling_down(...)
							end,
							["<C-u>"] = function(...)
								return require("telescope.actions").preview_scrolling_up(...)
							end,
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
						},
						n = {
							["q"] = function(...)
								return require("telescope.actions").close(...)
							end,
						},
					},
					borderchars = {
						{ "-", "|", "-", "|", "+", "+", "+", "+" },
						prompt = { "-", "|", " ", "│", "+", "+", "|", "|" },
						results = { "-", "|", "-", "|", "+", "+", "+", "+" },
						preview = { "-", "|", "-", "|", "+", "+", "+", "+" },
					},
					dynamic_preview_title = true,
					layout_strategy = "center",
					layout_config = {
						width = 0.95,
						height = 0.6,
						anchor = "N",
					},
				},
				extensions = {
					-- ["ui-select"] = {
					--   require("telescope.themes").get_dropdown({
					--     -- even more opts
					--   }),
					-- },
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					frecency = {
						show_scores = true,
						show_unindexed = true,
						ignore_patterns = { "*.git/*", "*/tmp/*" },
						disable_devicons = false,
						workspaces = {
							["conf"] = os.getenv("HOME") .. "/.config",
							["data"] = os.getenv("HOME") .. "/.local/share",
							["project"] = os.getenv("HOME") .. "/newegg",
							["wiki"] = os.getenv("HOME") .. "/wiki",
						},
					},
				},
			})
		end,
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			'nvim-tree/nvim-web-devicons',
			'SmiteshP/nvim-navic'
		},
		event = "VeryLazy",
		opts = {
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					{ "diagnostics" },
					{ "filetype", icon_only = false, separator = "", padding = { left = 1, right = 0 } },
					{ "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
					-- stylua: ignore
					{
						function() return require("nvim-navic").get_location() end,
						cond = function()
							return package.loaded["nvim-navic"] and
								require("nvim-navic").is_available()
						end,
					},
				},
				lualine_x = {
					-- stylua: ignore
					{
						function() return "  " .. require("dap").status() end,
						cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
					},
					{
						"diff",
					},
					{ "fileformat" },
					{ "encoding" },
				},
				lualine_y = {
					{ "progress", separator = " ",                  padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return " " .. os.date("%R")
					end,
				},
			}
		}
	},

	-- movation
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{
				"S",
				mode = { "n", "x", "o" },
				function() require("flash").treesitter() end,
				desc =
				"Flash Treesitter"
			},
			{
				"r",
				mode = "o",
				function() require("flash").remote() end,
				desc =
				"Remote Flash"
			},
			{
				"R",
				mode = { "o", "x" },
				function() require("flash").treesitter_search() end,
				desc =
				"Treesitter Search"
			},
			{
				"<c-s>",
				mode = { "c" },
				function() require("flash").toggle() end,
				desc =
				"Toggle Flash Search"
			},
		},
	},

	-- comments
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {
			options = {
				ignore_blank_line = true,
			},

			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				-- Toggle comment (like `gcip` - comment inner paragraph) for both
				-- Normal and Visual modes
				comment = "cc",

				-- Toggle comment on current line
				comment_line = "cc",

				-- Toggle comment on visual selection
				comment_visual = 'cc',

				-- Define 'comment' textobject (like `dgc` - delete whole comment block)
				-- textobject = 'gc',
			},
		},
	},

	-- better text-objects
	{
		"echasnovski/mini.ai",
		-- keys = {
		--   { "a", mode = { "x", "o" } },
		--   { "i", mode = { "x", "o" } },
		-- },
		event = "VeryLazy",
		dependencies = { "nvim-treesitter-textobjects" },
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
		end,
	},

	-- surround
	{
		"echasnovski/mini.surround",
		keys = function(_, keys)
			-- Populate the keys based on the user's options
			local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
			local opts = require("lazy.core.plugin").values(plugin, "opts", false)
			local mappings = {
				{ opts.mappings.add,            desc = "Add surrounding",                     mode = { "n", "v" } },
				{ opts.mappings.delete,         desc = "Delete surrounding" },
				{ opts.mappings.find,           desc = "Find right surrounding" },
				{ opts.mappings.find_left,      desc = "Find left surrounding" },
				{ opts.mappings.highlight,      desc = "Highlight surrounding" },
				{ opts.mappings.replace,        desc = "Replace surrounding" },
				{ opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
			}
			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			mappings = {
				add = "ys", -- Add surrounding in Normal and Visual modes
				delete = "ds", -- Delete surrounding
				find = "fs", -- Find surrounding (to the right)
				find_left = "Fs", -- Find surrounding (to the left)
				highlight = "hs", -- Highlight surrounding
				replace = "cs", -- Replace surrounding
				update_n_lines = "ns", -- Update `n_lines`
			},
		},
	},

	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true,
	},
	-- auto tag
	{
		"windwp/nvim-ts-autotag",
		config = true
	},

	{ "tpope/vim-repeat", event = "VeryLazy" },
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},
}
