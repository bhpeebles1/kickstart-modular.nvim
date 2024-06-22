return {
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Add the TypeScript and JavaScript formatters
        typescript = { 'eslint' },
        javascript = { 'eslint' },
        typescriptreact = { 'eslint' },
        javascriptreact = { 'eslint' },
      },
      formatters = {
        eslint = {
          command = 'eslint',
          args = { '--fix', '--stdin', '--stdin-filename', '%filepath' },
          stdin = true,
        },
      },
    },
  },
}
