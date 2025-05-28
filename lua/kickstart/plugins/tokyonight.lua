return {
  {
    'folke/tokyonight.nvim',
    init = function()
      -- Load the colorscheme here.
      vim.cmd.colorscheme 'tokyonight-night'

      -- Enable transparent background
      vim.cmd [[
        hi Normal guibg=NONE ctermbg=NONE
        hi LineNr guibg=NONE ctermbg=NONE
        hi SignColumn guibg=NONE ctermbg=NONE
        hi EndOfBuffer guibg=NONE ctermbg=NONE
      ]]

      -- Additional highlight configurations if needed
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
