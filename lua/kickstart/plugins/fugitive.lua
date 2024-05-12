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

          vim.keymap.set('n', '<leader>go', ':Git push -u origin ', vim.tbl_extend('force', opts, { desc = 'Git push origin' }))

          -- Keymap for pulling and rebasing with description
          vim.keymap.set('n', '<leader>gP', function()
            vim.cmd 'Git pull --rebase'
          end, vim.tbl_extend('force', opts, { desc = 'Git pull --rebase' }))
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
      -- Common function to extract branch name and execute a provided Git command
      local function execute_git_command_with_branch(cmd_base)
        local buf_name = vim.api.nvim_buf_get_name(0)
        -- Check if the buffer is likely a temporary buffer used for git operations
        if buf_name:match 'nvim%.%d+[/\\].+' then
          -- Run the command exactly as it would be in Vimscript
          local branch_name = vim.fn.expand '<cfile>'
          if branch_name ~= '' then
            vim.cmd(cmd_base .. ' ' .. branch_name)
            print(cmd_base .. ' ' .. branch_name)
          else
            print 'No branch name found under cursor.'
          end
        else
          -- Not in a branch-list buffer, prompt for a new branch name
          local branch_name = vim.fn.input 'Branch name: '
          if branch_name ~= '' then
            vim.cmd(cmd_base .. ' ' .. branch_name)
          end
        end
      end

      vim.keymap.set('n', '<leader>gb', function()
        execute_git_command_with_branch 'Git checkout'
      end, { desc = 'Smart Checkout Branch' })

      vim.keymap.set('n', '<leader>gm', function()
        execute_git_command_with_branch 'Git merge --no-ff'
      end, { desc = 'Smart Merge Branch' })
    end,
  },
}
