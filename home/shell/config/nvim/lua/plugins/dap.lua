return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
  },
  config = function()
    local dap = require'dap'
    local dap_ui = require'dapui'
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dap_ui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dap_ui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dap_ui.close()
    end

    vim.keymap.set('n', '<F5>', dap.continue, {})
    vim.keymap.set('n', '<F10>', dap.step_over, {})
    vim.keymap.set('n', '<F11>', dap.step_into, {})
    vim.keymap.set('n', '<F12>', dap.step_out, {})
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, {})

    dap_ui.setup{}
  end
}
