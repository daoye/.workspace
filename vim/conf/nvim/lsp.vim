set completeopt=menu,menuone,noselect

lua << EOF
require("mason").setup{
    log_level = vim.log.levels.DEBUG
}
require("mason-lspconfig").setup{
    automatic_installation = true
}
require("mason-null-ls").setup({
    automatic_setup = true,
    automatic_installation = true,
})
require("null-ls").setup()

local cmp_lsp = require('cmp_nvim_lsp')
local capabilities =  cmp_lsp.default_capabilities()

-- local capabilities = cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>fs', '<cmd>lua vim.lsp.buf.format({async = true})<CR>', opts)
    buf_set_keymap('v', '<leader>fs', '<cmd>lua vim.lsp.buf.range_formatting(vim.lsp.util.make_range_params())<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space><space>l', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
    buf_set_keymap('n', '<space><space>L', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)

    -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('v', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    -- buf_set_keymap('n', '<leader><leader>ls', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
    -- buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    -- buf_set_keymap('n', '<leader><leader>le', '<cmd>LspDiagnosticsAll<CR>', opts)
    -- buf_set_keymap('n', '[[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    -- buf_set_keymap('n', ']]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)


    -- go preview configs
    buf_set_keymap("n", "gd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {silent = true, noremap = true})
    buf_set_keymap("n", "gi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", {silent = true, noremap = true})
    buf_set_keymap("n", "q", "<cmd>lua require('goto-preview').close_all_win()<CR>", {silent = true, noremap = true})

    -- Highlightings cursor words.
    require 'illuminate'.on_attach(client)
    buf_set_keymap('n', '<a-u>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', {noremap=true})
    buf_set_keymap('n', '<a-d>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', {noremap=true})
end


require("mason-lspconfig").setup_handlers {
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
            on_attach = on_attach,
            flags = {
              debounce_text_changes = 150,
            },
            capabilities = capabilities
        }
    end,
    -- Next, you can provide targeted overrides for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    -- ["rust_analyzer"] = function ()
    --    require("rust-tools").setup {}
    -- end
}

require 'mason-null-ls'.setup_handlers() -- If `automatic_setup` is true.

-- UI customizing
local signs = { Error = "", Warn = "", Hint = "", Info = "" , Other = "﫠"}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({ 
    virtual_text = false,
    underline = false,
    update_in_insert = true,  
    severity_sort = false,
})
EOF
