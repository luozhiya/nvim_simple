local M = {}
M.plugin_installed = function(name)
  local plugins = require('module.plugins')
  for k, v in ipairs(plugins) do
    if vim.tbl_contains(v, name) then
      return true
    end
  end
end

M.is_windows = function()
  return vim.loop.os_uname().sysname == 'Windows_NT'
end
M.is_linux = function()
  return vim.loop.os_uname().sysname == 'Linux'
end

return M
