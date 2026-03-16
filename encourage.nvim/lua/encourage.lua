local M = {}

local default_encouragements = {
  'Great job! ✨',
  "You're doing great! 💪",
  'Keep up the good work! 🌟',
  'Well done! 🎉',
  'Onward and upward! 🚀',
  "You're on fire! 🔥",
  "You're a star! ⭐️",
  "You're amazing! 🌈",
  'That was awesome! 🎈',
  'Smart move. 🧠',
  'Bravo! 👏',
  'Nailed it. 🔨',
}

local function show_floating_message(message, timeout, row_offset, col_offset)
  local width = #message - 6
  local height = 1
  local buf = vim.api.nvim_create_buf(false, true)

  -- This puts the message in the bottom right corner of the current window
  local current_win = vim.api.nvim_get_current_win()
  local win_config = vim.api.nvim_win_get_config(current_win)
  local win_width = win_config.width
  local win_height = win_config.height

  -- local bubbleopts = {
  --   style = 'minimal',
  --   relative = 'win',
  --   win = current_win,
  --   width = 1,
  --   height = 1,
  --   row = win_height - row_offset + 1,
  --   col = win_width - col_offset+10,
  -- }
  local opts = {
    style = 'minimal',
    relative = 'win',
    win = current_win,
    width = width,
    height = height,
    row = win_height - height - row_offset,
    col = win_width - width - col_offset,
    border = {
      { '╭', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '╮', 'FloatBorder' },
      { '│', 'FloatBorder' },
      { '╯', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '╰', 'FloatBorder' },
      { '│', 'FloatBorder' },
    },
  }

  local win = vim.api.nvim_open_win(buf, false, opts)
  -- local win2 = vim.api.nvim_open_win(buf, false, bubbleopts)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { ' ' .. message .. ' ' })

  vim.api.nvim_win_set_option(win, 'winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder')
  -- vim.api.nvim_win_set_option(win2, 'winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder')

  -- Set a timer to close the window after 5 seconds
  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, timeout)
end

local function custom_write_message(encouragements, timeout, row_offset, col_offset)
  local message = encouragements[math.random(#encouragements)]
  show_floating_message(message, timeout, row_offset, col_offset)
end

function M.setup(opts)
  opts = opts or {}
  local encouragements = opts.messages or default_encouragements
  local timeout = opts.timeout or 5000
  local row_offset = 37
  local col_offset = 65
  local plugin = vim.api.nvim_create_augroup('CustomWriteMessage', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = plugin,
    callback = function()
      custom_write_message(encouragements, timeout, row_offset, col_offset)
    end,
  })
end

return M
