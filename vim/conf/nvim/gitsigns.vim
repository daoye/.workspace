lua << EOF
    require('gitsigns').setup {
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author><author_mail>, <author_time:%Y-%m-%d> - <summary>',
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']g', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        map('n', '[g', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        -- Actions
        --map({'n', 'v'}, '<leader>gs', ':Gitsigns stage_hunk<CR>')
        --map({'n', 'v'}, '<leader>gr', ':Gitsigns reset_hunk<CR>')
        --map('n', '<leader>gu', gs.undo_stage_hunk)
        -- map('n', '<leader>gS', gs.stage_buffer)
        -- map('n', '<leader>gR', gs.reset_buffer)
        -- map('n', '<leader>gp', gs.preview_hunk)
        --map('n', '<leader>gp', function() gs.blame_line{full=true} end)
        --map('n', '<leader>gb', gs.toggle_current_line_blame)
        -- map('n', '<leader>gd', gs.diffthis)
        -- map('n', '<leader>gD', function() gs.diffthis('~') end)
        -- map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        --map({'o', 'x'}, 'ig', ':<C-U>Gitsigns select_hunk<CR>')
      end
    }
EOF
