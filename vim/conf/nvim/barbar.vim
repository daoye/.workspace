lua << EOF
    vim.g.bufferline = {
      closable = false,
      clickable = false,
    }

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    -- Move to previous/next
    map('n', '<A-,>', ':BufferPrevious<CR>', opts)
    map('n', '<A-.>', ':BufferNext<CR>', opts)
    -- Re-order to previous/next
    map('n', '<A-<>', ':BufferMovePrevious<CR>', opts)
    map('n', '<A->>', ':BufferMoveNext<CR>', opts)
    -- Goto buffer in position...
    map('n', '<A-1>', ':BufferGoto 1<CR>', opts)
    map('n', '<A-2>', ':BufferGoto 2<CR>', opts)
    map('n', '<A-3>', ':BufferGoto 3<CR>', opts)
    map('n', '<A-4>', ':BufferGoto 4<CR>', opts)
    map('n', '<A-5>', ':BufferGoto 5<CR>', opts)
    map('n', '<A-6>', ':BufferGoto 6<CR>', opts)
    map('n', '<A-7>', ':BufferGoto 7<CR>', opts)
    map('n', '<A-8>', ':BufferGoto 8<CR>', opts)
    map('n', '<A-9>', ':BufferGoto 9<CR>', opts)
    map('n', '<A-0>', ':BufferLast<CR>', opts)
    -- Close buffer
    map('n', '<A-c>', ':BufferClose<CR>', opts)
    -- Wipeout buffer
    --                 :BufferWipeout<CR>
    -- Close commands
    --                 :BufferCloseAllButCurrent<CR>
    --                 :BufferCloseBuffersLeft<CR>
    --                 :BufferCloseBuffersRight<CR>
    -- Magic buffer-picking mode
    map('n', '<A-p>', ':BufferPick<CR>', opts)
    -- Sort automatically by...
    map('n', '<Space>bb', ':BufferOrderByBufferNumber<CR>', opts)
    map('n', '<Space>bd', ':BufferOrderByDirectory<CR>', opts)
    map('n', '<Space>bl', ':BufferOrderByLanguage<CR>', opts)

    -- Other:
    -- :BarbarEnable - enables barbar (enabled by default)
    -- :BarbarDisable - very bad command, should never be used
EOF


" Meaning of terms:
"
" format: "Buffer" + status + part
"
" status:
"     *Current: current buffer
"     *Visible: visible but not current buffer
"    *Inactive: invisible but not current buffer
"
" part:
"        *Icon: filetype icon
"       *Index: buffer index
"         *Mod: when modified
"        *Sign: the separator between buffers
"      *Target: letter in buffer-picking mode
"
" BufferTabpages: tabpage indicator
" BufferTabpageFill: filler after the buffer section
" BufferOffset: offset section, created with set_offset()
" echo 'hello'
