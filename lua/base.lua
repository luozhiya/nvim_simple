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

M.merge = function(x, y)
  for k, v in pairs(y) do
    if type(v) == 'table' then
      x[k] = M.merge(x[k], y[k])
    else
      x[k] = v
    end
  end
  return x
end

---Merge two tables recursively
---@generic T
---@param v1 T
---@param v2 T
---@return T
M.merge_recursively = function(v1, v2)
  local merge1 = type(v1) == 'table' and (not vim.tbl_islist(v1) or vim.tbl_isempty(v1))
  local merge2 = type(v2) == 'table' and (not vim.tbl_islist(v2) or vim.tbl_isempty(v2))
  if merge1 and merge2 then
    local new_tbl = {}
    for k, v in pairs(v2) do
      new_tbl[k] = M.merge_recursively(v1[k], v)
    end
    for k, v in pairs(v1) do
      if v2[k] == nil and v ~= vim.NIL then
        new_tbl[k] = v
      end
    end
    return new_tbl
  end
  if v1 == vim.NIL then
    return nil
  end
  if v1 == nil then
    if v2 == vim.NIL then
      return nil
    else
      return v2
    end
  end
  if v1 == true then
    if merge2 then
      return v2
    end
    return {}
  end

  return v1
end

return M
