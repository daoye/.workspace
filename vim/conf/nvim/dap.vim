lua << EOF
local dap = require('dap')
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")


vim.fn.sign_define('DapBreakpoint', {text='🐞', texthl='', linehl='', numhl=''})

dapui.setup({
  layouts = {
    {
      elements = {
        "breakpoints",
        "stacks",
        "watches",
        "scopes",
      },
      size = 60, 
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.3, -- 25% of total lines
      position = "bottom",
    },
  },
})
daptext.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
EOF

nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> <C-F5> <Cmd>lua require'dap'.terminate()<CR>
nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
nnoremap <silent> <S-F10> <Cmd>lua require'dap'.run_to_cursor()<CR>

nnoremap <silent> <F9> <Cmd>lua require'dap'.toggle_breakpoint()<CR>

nnoremap <silent> <Leader>b <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader><Leader>b <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <S-F9> <Cmd>lua require'dap'.clear_breakpoints()<CR>
" nnoremap <silent> <leader><F5> <Cmd>lua require('dap.ext.vscode').load_launchjs(nil, { node = {'typescript', 'javascript'}})<CR>

nnoremap <silent> <S-F5> <Cmd>lua require'dapui'.toggle()<CR>

