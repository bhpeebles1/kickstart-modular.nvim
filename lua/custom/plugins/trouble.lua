return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  config = function()
    vim.keymap.set('n', '<leader>xx', function()
      require('trouble').toggle()
    end, { desc = 'Trouble Toggle' })
    vim.keymap.set('n', '<leader>xw', function()
      require('trouble').toggle 'workspace_diagnostics'
    end, { desc = 'Workspace Diagnostics' })
    vim.keymap.set('n', '<leader>[t', function()
      require('trouble').next { skip_groups = true, jump = true }
    end, { desc = 'Jump to next Trouble' })
    vim.keymap.set('n', '<leader>]t', function()
      require('trouble').previous { skip_groups = true, jump = true }
    end, { desc = 'Jump to previous Trouble' })

    -- Hotkeys below seem useless, still testing c-t
    --[[ vim.keymap.set('n', '<leader>xd', function() require('trouble').toggle 'document_diagnostics' end, { desc = 'Document Diagnostics' })
    vim.keymap.set('n', '<leader>xq', function() require('trouble').toggle 'quickfix' end, { desc = 'Quickfix' })
    vim.keymap.set('n', '<leader>xl', function() require('trouble').toggle 'loclist' end, { desc = 'Loc List' })
    vim.keymap.set('n', 'gR', function() require('trouble').toggle 'lsp_references' end, { desc = 'LSP References' }) ]]

    local trouble = require 'trouble.sources.telescope'

    local telescope = require 'telescope'

    telescope.setup {
      defaults = {
        mappings = {
          i = { ['<c-t>'] = trouble.open},
          n = { ['<c-t>'] = trouble.open},
        },
      },
    }
  end,
}
