return {
  {
    'tpope/vim-fugitive',
    config = function()
      -- Basic Git command
      vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git status' })

      -- Automate key binding configuration for fugitive buffers
      vim.api.nvim_create_autocmd('BufWinEnter', {
        pattern = '*',
        callback = function()
          if vim.bo.filetype ~= 'fugitive' then
            return
          end

          local bufnr = vim.api.nvim_get_current_buf()
          local opts = { buffer = bufnr, remap = false }

          -- Keymap for pushing changes with description
          vim.keymap.set('n', '<leader>gp', function()
            vim.cmd 'Git push'
          end, vim.tbl_extend('force', opts, { desc = 'Git push' }))

          -- Keymap for pulling and rebasing with description
          vim.keymap.set('n', '<leader>gP', function()
            vim.cmd 'Git pull --rebase'
          end, vim.tbl_extend('force', opts, { desc = 'Git pull --rebase' }))

          -- Set up tracking branch on push with description
          vim.keymap.set('n', '<leader>go', ':Git push -u origin ', vim.tbl_extend('force', opts, { desc = 'Git push origin' }))
        end,
      })

      -- Keymaps for diffget operations with descriptions
      vim.keymap.set('n', 'gf', function()
        vim.cmd 'diffget //2'
      end, { desc = 'Get diff from LEFT' })
      vim.keymap.set('n', 'gj', function()
        vim.cmd 'diffget //3'
      end, { desc = 'Get diff from RIGHT' })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'gitcommit',
        callback = function()
          -- Keymap to quit commit message and abort commit
          vim.keymap.set('n', '<leader>gc', ':q!<CR>', { buffer = true, desc = 'Cancel Commit' })
        end,
      })
      vim.keymap.set('n', '<leader>gb', function()
        local branch_name = vim.fn.input 'Branch name: '
        if branch_name ~= '' then
          vim.cmd('Git checkout -b ' .. branch_name)
        end
      end, { desc = 'Checkout new branch' })
      vim.keymap.set('n', '<leader>gv', function()
        vim.cmd 'Git branch'
      end, { desc = 'View Git branches' })
      vim.keymap.set('n', '<leader>gd', function()
        vim.cmd 'Gdiff'
      end, { desc = 'Open Git diff mergetool' })
      vim.keymap.set('n', '<leader>gm', function()
        local branch_name = vim.fn.input 'Branch name: '
        if branch_name ~= '' then
          vim.cmd('Git merge --no-ff ' .. branch_name)
        end
      end, { desc = 'Merge branch' })
    end,
  },
}
