lua << EOF
local dap = require('dap')
dap.set_log_level('TRACE')


-- dap.adapters.node = {
--     type = 'executable',
--     command = 'node',
--     args = {os.getenv('HOME') .. '/.debugger/vscode-node-debug2/out/src/nodeDebug.js'},
-- }

-- dap.adapters.node = {
--     type = 'server',
--     host = '127.0.0.1',
--     port = 12374
-- }


local dap = require('dap')
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/.debugger/vscode-node-debug2/out/src/nodeDebug.js'},
}

dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
    program= '${workspaceFolder}/dist/development/server.js',
    args= {'build.react.prod'},
    outFiles= {'${workspaceFolder}/**/*.js'}
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

dap.configurations.typescript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
    program= '${workspaceFolder}/dist/development/server.js',
    args= {'build.react.prod'},
    outFiles= {'${workspaceFolder}/**/*.js'}
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

vim.fn.sign_define('DapBreakpoint', {text='🐞', texthl='', linehl='', numhl=''})

require("nvim-dap-virtual-text").setup()
EOF

nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <Leader><Leader>b <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader>pb <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <S-F10> <Cmd>lua require'dap'.run_to_cursor()<CR>
nnoremap <silent> <leader><F5> <Cmd>lua require('dap.ext.vscode').load_launchjs(nil, { node = {'typescript', 'javascript'}})<CR>
