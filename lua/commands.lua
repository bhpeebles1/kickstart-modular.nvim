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
