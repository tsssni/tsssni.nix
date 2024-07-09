return {
  'rmagatti/auto-session',
  config = function()
    local function restore_nvim_tree()
      local buffers_list = vim.api.nvim_exec2(':buffers', {output = true}).output
      if buffers_list and string.find(buffers_list, "NvimTree") then
        vim.cmd'NvimTreeOpen'
      end
    end

    require'auto-session'.setup {
      log_level = 'error',
      auto_session_suppress_dirs = {'~/', '~/Projects', '~/Downloads', '/'},
      post_restore_cmds = {restore_nvim_tree},
    }
  end
}
