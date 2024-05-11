return {
  {
    'tpope/vim-fugitive',
    config = function()
      -- Basic Git command
      vim.keymap.set('n', '<leader>gs', vim.cmd.Git)

      -- Automate key binding configuration for fugitive buffers
      vim.api.nvim_create_autocmd('BufWinEnter', {
        pattern = '*',
        callback = function()
          if vim.bo.filetype ~= 'fugitive' then
            return
          end

          local bufnr = vim.api.nvim_get_current_buf()
          local opts = { buffer = bufnr, remap = false }

          -- Keymap for pushing changes
          vim.keymap.set('n', '<leader>p', function()
            vim.cmd 'Git push'
          end, opts)

          -- Keymap for pulling and rebasing
          vim.keymap.set('n', '<leader>P', function()
            vim.cmd 'Git pull --rebase'
          end, opts)

          -- Set up tracking branch on push
          vim.keymap.set('n', '<leader>t', ':Git push -u origin ', opts)
        end,
      })

      -- Keymaps for diffget operations
      vim.keymap.set('n', 'gu', '<cmd>diffget //2<CR>')
      vim.keymap.set('n', 'gh', '<cmd>diffget //3<CR>')
    end,
  },
}
