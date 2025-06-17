-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Stop Debugger',
    },
    {
      '<F6>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F7>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F8>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F9>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<F10>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },

    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },

    {
      '<leader>dq',
      function()
        require('dap').terminate()
        require('dapui').close()
      end,
      desc = 'Debug: Quit Debugger',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve', -- Go
        'php-debug-adapter', -- PHP / Xdebug
        'python', -- debugpy (Python)
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    require('dapui').setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },

      mappings = {
        expand = 'o',
        open = 'O',
        remove = 'd',
        edit = 'e',
        repl = 'r',
      },

      element_mappings = {},

      expand_lines = false,
      force_buffers = false,

      controls = {
        enabled = true,
        element = 'repl',
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
            { id = 'scopes', size = 0.7 },
            { id = 'breakpoints', size = 0.1 },
            { id = 'stacks', size = 0.1 },
            { id = 'watches', size = 0.1 },
          },
          size = 60,
          position = 'left',
        },
        {
          elements = { 'repl', 'console' },
          size = 15,
          position = 'bottom',
        },
      },

      floating = {
        max_height = nil,
        max_width = nil,
        border = 'single',
        mappings = { close = { 'q', '<Esc>' } },
      },

      windows = { indent = 1 },

      render = {
        max_type_length = nil,
        indent = 1, -- <— add this to satisfy the type
      },
    }


    -- swallow all telemetry output events
    dap.listeners.before.event_output['filter_telemetry'] = function(_, body)
      if body.category == 'telemetry' then
        return true -- returning true here stops further handling
      end
    end

    -- swallow the raw debugpySockets event
    dap.listeners.before['debugpySockets']['filter_sockets'] = function()
      return true
    end
    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
