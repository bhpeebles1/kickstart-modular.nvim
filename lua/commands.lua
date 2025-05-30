-- File: ~/.config/nvim/lua/custom/commands.lua

-- Set custom external commands for ls, rm, and rmdir
vim.cmd [[
  cnoreabbrev ls cmd /c dir
  cnoreabbrev rm cmd /c del
  cnoreabbrev rmdir cmd /c rmdir /S /Q
]]
-- Auto-reload files when they change on disk
vim.cmd 'set autoread' -- Enable autoreading files
vim.api.nvim_create_augroup('AutoRead', { clear = true }) -- Create an autocommand group
vim.api.nvim_create_autocmd('CursorHold', {
  group = 'AutoRead',
  pattern = '*',
  callback = function()
    vim.cmd 'checktime' -- Check if the file has been modified outside of Neovim
  end,
})

function LineNumberColors()
  vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#5FA8D3', bold = true })
  vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white', bold = true })
  vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#b588e8', bold = true })
end

vim.opt.tabstop = 2       -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 2    -- Size of an indent
vim.opt.softtabstop = 2   -- Number of spaces for <Tab> in insert mode
vim.opt.expandtab = true  -- Convert tabs to spaces

LineNumberColors()
