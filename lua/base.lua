local M = {}

local cached = {}
M.cached = cached
M.installed = function(name)
  -- if vim.tbl_isempty(cached) then
  -- for _, plugin in pairs(require('module.plugins')) do
  -- table.insert(cached, plugin[1])
  -- end
  -- end
  -- return vim.tbl_contains(cached, name)
  return true
end

M.is_windows = function() return vim.loop.os_uname().sysname == 'Windows_NT' end
M.is_linux = function() return vim.loop.os_uname().sysname == 'Linux' end

-- cp from lazy.nvim util
function M.file_exists(file) return vim.loop.fs_stat(file) ~= nil end

-- cp from lazy.nvim util
function M.open(uri)
  local cmd
  if vim.fn.has('win32') == 1 then
    cmd = { 'explorer', uri }
    cmd = table.concat(cmd, ' '):gsub('/', '\\')
  elseif vim.fn.has('macunix') == 1 then
    cmd = { 'open', uri }
  else
    if vim.fn.executable('xdg-open') == 1 then
      cmd = { 'xdg-open', uri }
    elseif vim.fn.executable('wslview') == 1 then
      cmd = { 'wslview', uri }
    else
      cmd = { 'open', uri }
    end
  end
  local ret = vim.fn.jobstart(cmd, { detach = true })
  if ret <= 0 then
    local msg = {
      'Failed to open uri',
      ret,
      vim.inspect(cmd),
    }
    vim.notify(table.concat(msg, '\n'), vim.log.levels.ERROR)
  end
end

M.copy_content = function() end

M.copy_path = function() end

M.copy_relative_path = function() end

M.copy_name = function() end

M.copy_name_ext = function() end

M.reveal_in_file_explorer = function() end

M.reveal_in_tree = function() end

return M
