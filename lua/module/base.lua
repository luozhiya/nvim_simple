local M = {}
M.plugin_installed = function(name)
  local plugins = require('module.plugins')
  for k, v in ipairs(plugins) do
    if vim.tbl_contains(v, name) then
      return true
    end
  end
end

return M
