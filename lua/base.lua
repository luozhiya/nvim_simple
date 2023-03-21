local M = {}

local cached = {}
M.cached = cached
M.installed = function(name)
  if vim.tbl_isempty(cached) then
    for _, plugin in pairs(require('module.plugins')) do
      table.insert(cached, plugin[1])
    end
  end
  return vim.tbl_contains(cached, name)
end

M.is_windows = function()
  return vim.loop.os_uname().sysname == 'Windows_NT'
end
M.is_linux = function()
  return vim.loop.os_uname().sysname == 'Linux'
end

return M
