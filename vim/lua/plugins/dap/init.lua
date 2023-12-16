local last_run
local widget_scopes
local widget_frames
local widget_threads

return {
  "mfussenegger/nvim-dap",

  dependencies = {
    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },

    -- mason.nvim integration
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        -- automatic_setup = { exclude = { "python" } },
        automatic_setup = {

        },

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {
          python = function(config)
            local venv_path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
            local python = venv_path and (venv_path .. "/bin/python") or nil

            table.insert(config.configurations, {
              name = "Python: Attach",
              type = "python",
              request = "attach",
              processId = "${command:pickProcess}",
            })

            table.insert(config.configurations, {
              name = "Python: Flask",
              type = "python",
              request = "launch",
              module = "flask",
              python = python,
              env = {
                FLASK_APP = "app",
                FLASK_DEBUG = "1",
              },
              args = {
                "run",
                "--no-debugger",
                "--no-reload",
              },
              jinja = true,
              justMyCode = true,
            })

            require("mason-nvim-dap").default_setup(config)
          end,
        },

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          "python",
          "js",
        },
      },
    },
  },

  -- stylua: ignore
  keys = {
    {
      "<F5>",
      function()
        local dap = require("dap")
        if not dap.session() and last_run then
          dap.run_last()
          return
        end

        dap.continue()
      end,
      desc = "Continue with picked configuration"
    },
    { "<S-F5>",     function() require("dap").terminate() end,                                                   desc = "Terminate" },
    { "<C-F5>",     function() require("dap").restart() end,                                                     desc = "Restart" },
    { "<A-F5>",     function() require("dap").continue() end,                                                    desc = "Continue" },
    { "<F6>",       function() require("dap").run_to_cursor() end,                                               desc = "Run to Cursor" },
    { "<F9>",       function() require("dap").toggle_breakpoint() end,                                           desc = "Toggle Breakpoint" },
    { "<C-F9>",     function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,        desc = "Breakpoint with condition" },
    { "<S-F9>",     function() require("dap").clear_breakpoints() end,                                           desc = "Clear breakpoints" },
    { "<A-F9>",     function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = "Breakpoint with log" },
    { "<F10>",      function() require("dap").step_over() end,                                                   desc = "Step Over" },
    { "<S-F10>",    function() require("dap").step_out() end,                                                    desc = "Step Out" },
    { "<F11>",      function() require("dap").step_into() end,                                                   desc = "Step Into" },
    { "<F1>",       function() require("dap.repl").toggle({ height = 10 }) end,                                  desc = "Toggle repl buffer" },
    -- { "<C-k>", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },

    { "<leader>dg", function() require("dap").goto_() end,                                                       desc = "Go to line (no execute)" },
    { "<leader>dj", function() require("dap").down() end,                                                        desc = "Down" },
    { "<leader>dk", function() require("dap").up() end,                                                          desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end,                                                    desc = "Run Last" },
    { "<leader>dp", function() require("dap").pause() end,                                                       desc = "Pause" },
    { "<leader>ds", function() require("dap").session() end,                                                     desc = "Session" },
  },

  config = function()
    local Config = require("conf")
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    for name, sign in pairs(Config.icons.dap) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end

    local dap = require("dap")
    dap.listeners.after.event_initialized["aprilzz"] = function(session)
      last_run = session.config
      dap.repl.open({ height = 10 }, "belowright split")
    end
    dap.set_log_level("TRACE")
  end,
}
