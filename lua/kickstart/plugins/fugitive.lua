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
          local function push_with_upstream_check()
            local branch_info = vim.fn.systemlist 'git rev-parse --abbrev-ref --symbolic-full-name @{u}'

            if vim.v.shell_error ~= 0 then -- No upstream set
              local answer = vim.fn.input "No upstream set. Push with setting upstream to 'origin'? (y/n): "
              if answer == 'y' then
                vim.cmd 'Git push -u origin HEAD'
              else
                print 'Push cancelled.'
              end
            else
              vim.cmd 'Git push'
            end
          end

          vim.keymap.set('n', '<leader>gp', push_with_upstream_check, { desc = 'Git push with upstream check' })

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
      vim.keymap.set('n', '<leader>gx', function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        print('Buffer Name: ' .. buf_name) -- Debug print to understand what the buffer name is

        -- Place your conditional logic here based on the debug output
      end, { desc = 'Debug: Print buffer name and filetype' })
      vim.keymap.set('n', '<leader>gb', function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        -- Check if the buffer is likely a temporary buffer used for git operations
        if buf_name:match 'nvim%.%d+[/\\].+' then
          -- Attempt to run the command exactly as it would be in Vimscript
          vim.cmd('Git checkout ' .. vim.fn.expand '<cfile>' .. ' --')
        else
          -- Not in a branch-list buffer, prompt for a new branch name
          local branch_name = vim.fn.input 'Branch name: '
          if branch_name ~= '' then
            vim.cmd('Git checkout -b ' .. branch_name)
          end
        end
      end, { desc = 'Smart Checkout Branch' })
      vim.keymap.set('n', '<leader>gv', function()
        vim.cmd 'Git branch'
      end, { desc = 'View Git branches' })
      vim.keymap.set('n', '<leader>gd', function()
        vim.cmd 'Gdiff'
      end, { desc = 'Open Git diff mergetool' })
      vim.keymap.set('n', '<leader>gm', function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        -- Determine if the buffer name suggests a branch listing
        if buf_name:match 'nvim%.%d+[/\\].+' then
          -- Attempt to get the branch name directly under the cursor
          local branch_name = vim.fn.getline '.'
          -- Check if the line has a valid branch name
          if branch_name:match '^%s*[%w-_.]+%s*$' then
            -- Strip unwanted spaces if any
            branch_name = branch_name:match '^%s*(.-)%s*$'
            -- Execute the merge command
            vim.cmd('Git merge --no-ff ' .. branch_name)
          else
            print 'No valid branch name under cursor.'
          end
        else
          -- Not in a branch-list buffer, prompt for a new branch name
          local branch_name = vim.fn.input 'Branch name to merge: '
          if branch_name ~= '' then
            vim.cmd('Git merge --no-ff ' .. branch_name)
          end
        end
      end, { desc = 'Smart Merge Branch' })
    end,
  },
}
