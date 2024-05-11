-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- -- Set hotkeys for git mergetool
-- -- Define keymaps for picking changes in merge conflicts
-- ONLY UNCOMMENT IF FUGITIVE DOESN'T WORK I GUESS - PROBABLY DELETE LATER
--[[ vim.keymap.set('n', '<leader>gf', function()
  vim.cmd 'diffget LO'
end, { desc = 'Pick changes from Local (Left) file' })

vim.keymap.set('n', '<leader>gj', function()
  vim.cmd 'diffget REM'
end, { desc = 'Pick changes from Remote (Right) file' })

vim.keymap.set('n', '<leader>gb', function()
  vim.cmd 'diffget BASE'
end, { desc = 'Pick changes from Base (Common Ancestor) file' }) ]]

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Enter current file directory
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Move selected text up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Keep cursor position while moving lines upwards
vim.keymap.set('n', 'J', 'mzJ`z')

-- Keep screen centered while jumping up and down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Keep screen centered while searching
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- Delete highlighted word and add to void register (paste without yanking)
vim.keymap.set('x', '<leader>p', '"_dP')

-- yank into system clipboard
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+y')

-- Disable Q hotkey
vim.keymap.set('n', 'Q', '<nop>')

-- Quickfix navigation to find errors or something lol
vim.keymap.set('n', '<leader><C-n>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<leader><C-p>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')
vim.keymap.set('n', '<C-v>', '<C-q>')

-- Find and replace realtime
vim.keymap.set('n', '<leader>rr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Double space :so
vim.keymap.set('n', '<leader>so', function()
  vim.cmd 'so'
end, { desc = ':so' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<leader><C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<leader><C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<leader><C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<leader><C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Set line numbers in netrw
vim.cmd [[let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro']]

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
