return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',
        'php-debug-adapter',
      },
    }

    -- Basic debugging keymaps
    vim.keymap.set('n', '<F5>', dap.terminate, { desc = 'Debug: Stop Debugger' })
    vim.keymap.set('n', '<F6>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F7>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F8>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F9>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<F10>', dapui.toggle, { desc = 'Debug: See last session result.' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup with customized layout
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.7 }, -- Increase the size of the scopes window
            { id = 'breakpoints', size = 0.1 },
            { id = 'stacks', size = 0.1 },
            { id = 'watches', size = 0.1 },
          },
          size = 60, -- Width of the left layout
          position = 'left',
        },
        {
          elements = {
            'repl',
            'console',
          },
          size = 15, -- Height of the bottom layout
          position = 'bottom',
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      windows = { indent = 1 },
    }


    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Keybinding to quit debugger
    vim.keymap.set('n', '<leader>dq', function()
      dap.terminate()
      dapui.close()
    end, { desc = 'Debug: Quit Debugger' })

    -- PHP Xdebug configuration
    dap.adapters.php = {
      type = 'executable',
      command = 'node',
      args = { 'C:\\Users\\blake\\vscode-php-debug\\out\\phpDebug.js' },
    }

    dap.configurations.php = {
      {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003,
        pathMappings = {
          ['/var/www/app'] = 'C:\\Users\\blake\\BlueArrow\\base-project\\app',
          ['/var/www/config'] = 'C:\\Users\\blake\\BlueArrow\\base-project\\config',
          ['/var/www/database'] = 'C:\\Users\\blake\\BlueArrow\\base-project\\database',
          ['/var/www/public'] = 'C:\\Users\\blake\\BlueArrow\\base-project\\public',
          ['/var/www/resources'] = 'C:\\Users\\blake\\BlueArrow\\base-project\\resources',
          ['/var/www/routes'] = 'C:\\Users\\blake\\BlueArrow\\base-project\\routes',
          ['/var/www/storage'] = 'C:\\Users\\blake\\BlueArrow\\base-project\\storage',
          ['/var/www/tests'] = 'C:\\Users\\blake\\BlueArrow\\base-project\\tests',
          ['/var/www/scripts'] = 'C:\\Users\\blake\\BlueArrow\\base-project\\scripts',
          ['/var/www/vendor'] = 'C:\\Users\\blake\\BlueArrow\\base-project\\vendor',
          ['/var/www/artisan'] = 'C:\\Users\\blake\\BlueArrow\\base-project\\artisan',
        },
      },
    }

    local function get_python_path()
      local venv_path = vim.fn.getcwd() .. '/venv'
      if vim.fn.executable(venv_path .. '/bin/python') == 1 then
        return venv_path .. '/bin/python'
      elseif vim.fn.executable(venv_path .. '/Scripts/python.exe') == 1 then
        return venv_path .. '/Scripts/python.exe'
      else
        return 'python'
      end
    end

    dap.adapters.python = {
      type = 'executable',
      command = get_python_path(),
      args = { '-m', 'debugpy.adapter' },
    }

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = get_python_path()
      },
    }

  end,
}
