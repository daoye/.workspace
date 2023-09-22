return {

  -- add typescript to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.tsserver
        tsserver = {
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
      setup = {
        tsserver = function(_, opts)
          require("util").on_attach(function(client, buffer)
            if client.name == "tsserver" then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", { buffer = buffer, desc = "Organize Imports" })
              -- stylua: ignore
              vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
            end
          end)
          require("typescript").setup({ server = opts })
          return true
        end,
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      table.insert(opts.sources, require("typescript.extensions.null-ls.code-actions"))
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
      "mason.nvim",
    },
    opts = function(_, opts)
      local dap = require("dap")

      for _, language in ipairs({ "javascriptreact", "typescriptreact", "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            name = "Launch Program",
            type = "pwa-node",
            request = "launch",
            sourceMaps = true,
            cwd = "${workspaceFolder}",
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            outFiles = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            skipFiles = { "**/node_modules/**" },
          },
          {
            name = "Attach Program",
            type = "pwa-node",
            request = "attach",
            processId = function()
              return require("dap.utils").pick_process({
                filter = function(proc)
                  return string.find(proc.name, ".vscode") == nil
                    and string.find(proc.name, ".local") == nil
                    and string.find(proc.name, ".nvm") == nil
                    and string.find(proc.name, ".nvm") == nil
                    and string.find(proc.name, "Application") == nil
                    and string.find(proc.name, "node") ~= nil
                end,
              })
            end,
            sourceMaps = true,
            cwd = "${workspaceFolder}",
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            outFiles = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            skipFiles = { "**/node_modules/**" },
          },
        }
      end

      opts.debugger_cmd = { vim.fn.exepath("js-debug-adapter") }
    end,
  },
}
