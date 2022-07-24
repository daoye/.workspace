set completeopt=menu,menuone,noselect

lua << EOF
local lsp_installer = require("nvim-lsp-installer")
local cmp_lsp = require('cmp_nvim_lsp')
-- local folding = require('folding')

local capabilities = cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>fs', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('v', '<leader>fs', '<cmd>lua vim.lsp.buf.range_formatting(vim.lsp.util.make_range_params())<CR>', opts)
    -- buf_set_keymap('n', '<leader><space>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader><leader><space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    --  buf_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    --  buf_set_keymap('v', '<leader>la', '<cmd>lua vim.lsp.buf.range_code_action(vim.lsp.util.make_range_params())<CR>', opts)
    --  buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    --  buf_set_keymap('n', '<leader><leader>ls', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
    --  buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    --  buf_set_keymap('n', '<leader>le', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    --  buf_set_keymap('n', '<leader><leader>le', '<cmd>LspDiagnosticsAll<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    --  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space><space>l', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
    buf_set_keymap('n', '<space><space>L', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
    -- buf_set_keymap('n', '[[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    -- buf_set_keymap('n', ']]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>?', '<cmd>lua vim.diagnostic.hide()<CR>', opts)

    -- saga configs
    local map = vim.api.nvim_buf_set_keymap
    map(0, "n", "<leader>rn", "<cmd>Lspsaga rename<cr>", {silent = true, noremap = true})
    map(0, "n", "<leader>la", "<cmd>Lspsaga code_action<cr>", {silent = true, noremap = true})
    map(0, "x", "<leader><leader>la", ":<c-u>Lspsaga range_code_action<cr>", {silent = true, noremap = true})
    map(0, "n", "K",  "<cmd>Lspsaga hover_doc<cr>", {silent = true, noremap = true})
    map(0, "n", "?", "<cmd>Lspsaga show_line_diagnostics<cr>", {silent = true, noremap = true})
    map(0, "n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", {silent = true, noremap = true})
    map(0, "n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", {silent = true, noremap = true})
    map(0, "n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>", {})
    map(0, "n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>", {})


    -- go preview configs
    buf_set_keymap("n", "<leader>gd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {silent = true, noremap = true})
    buf_set_keymap("n", "<leader>gi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", {silent = true, noremap = true})
    buf_set_keymap("n", "q", "<cmd>lua require('goto-preview').close_all_win()<CR>", {silent = true, noremap = true})

    -- Highlightings cursor words.
    require 'illuminate'.on_attach(client)
    buf_set_keymap('n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', {noremap=true})
    -- buf_set_keymap('n', '<a-p>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', {noremap=true})
end

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities
  }

  server:setup(opts)
end)
EOF
