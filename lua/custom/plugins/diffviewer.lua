return {
  'sindrets/diffview.nvim',
  version = '*',
  config = function()
    require('diffview').setup{}
  end,
  keys = {
    { '<leader>hf', ':DiffviewFileHistory<CR>', desc = 'Open Diffview File History' }
  }
}
